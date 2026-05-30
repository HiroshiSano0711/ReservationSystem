require 'rails_helper'

RSpec.describe Services::SlotCalculator, type: :model do
  let(:team) { create(:team) }
  let(:team_business_setting) do
    create(:team_business_setting, :with_weekly_business_hours,
      team: team,
      reservation_start_delay_days: 0
    )
  end
  let(:service_menu) { create(:service_menu, team: team, duration: 80, required_staff_count: 1) }
  let(:staff) { create(:staff, team: team) }
  let(:date) { FIXED_TIME.call.to_date }  # 2025-01-01 (水曜日)

  subject(:calculator) do
    described_class.new(
      team: team,
      business_setting: team_business_setting,
      service_menus: [ service_menu ],
      selected_staff: nil
    )
  end

  before do
    allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call)
    allow(Time.zone).to receive(:now).and_return(FIXED_TIME.call)
    allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)
    allow(Time).to receive(:current).and_return(FIXED_TIME.call)
  end

  describe '#generate_slots_for_date' do
    before do
      staff.service_menus << service_menu
    end

    context '予約なしの場合' do
      it '営業時間内の全枠を返す' do
        slots = calculator.generate_slots_for_date(date, {})

        expect(slots).to be_present
        expect(slots.first[:start]).to eq(Time.zone.parse("#{date} 09:00"))
        expect(slots.last[:end]).to eq(Time.zone.parse("#{date} 18:00"))
      end

      # TODO: ユーザーの設定によって10分刻みか15分刻みか変更できる仕様になる。
      # よって、営業設定によってインターバルが正常であることを確認するテストに書き換える
      it '10分刻みの枠を返す' do
        slots = calculator.generate_slots_for_date(date, {})

        expect(slots[0][:start]).to eq(Time.zone.parse("#{date} 09:00"))
        expect(slots[1][:start]).to eq(Time.zone.parse("#{date} 09:10"))
      end
    end

    context 'スタッフ関連' do
      let(:reservations_by_date) do
        Reservation.where(start_time: FIXED_TIME.call, status: :finalized)
                   .group_by { |r| r.start_time.to_date }
      end

      context 'スタッフが1人で予約が1件ある場合' do
        before do
          create(:reservation,
            team: team,
            start_time: FIXED_TIME.call + 1.hour,
            end_time: FIXED_TIME.call + 2.hours,
            required_staff_count: 1
          )
        end

        it '予約と重複する枠が除外される' do
          slots = calculator.generate_slots_for_date(date, reservations_by_date)
          r_start_time = FIXED_TIME.call + 1.hour
          r_end_time = FIXED_TIME.call + 2.hour

          # 10:00~11:00に予約が入っている状態

          free_slots = slots.select do |slot|
            slot[:start] >= r_end_time || slot[:end] <= r_start_time
          end

          overlapping_slots = free_slots.select do |slot|
            slot[:start] < r_end_time && slot[:end] > r_start_time
          end

          expect(overlapping_slots).to be_empty
        end

        it '予約と重複しない枠は含まれる' do
          slots = calculator.generate_slots_for_date(date, reservations_by_date)

          r_start_time = FIXED_TIME.call + 1.hour
          r_end_time = FIXED_TIME.call + 2.hour

          # 10:00~11:00に予約が入っている状態

          free_slots = slots.select do |slot|
            slot[:start] >= r_end_time || slot[:end] <= r_start_time
          end

          border_slots = free_slots.select do |slot|
            slot[:start] == r_end_time ||
            slot[:end] == r_start_time
          end

          expect(border_slots).to be_present
        end
      end

      context 'スタッフが2人で予約が1件ある場合' do
        let(:staff2) { create(:staff, team: team) }

        before do
          staff2.service_menus << service_menu
          create(:reservation,
            team: team,
            start_time: Time.zone.local(2025, 1, 1, 10, 0, 0),
            end_time: Time.zone.local(2025, 1, 1, 11, 0, 0),
            required_staff_count: 1
          )
        end

        it '予約と重複する枠も含まれる（空きスタッフが残っているため）' do
          slots = calculator.generate_slots_for_date(date, reservations_by_date)

          overlapping = slots.select do |slot|
            slot[:start] < Time.zone.parse("#{date} 11:00") &&
              slot[:end] > Time.zone.parse("#{date} 10:00")
          end

          expect(overlapping).not_to be_empty
        end
      end
    end
  end
end

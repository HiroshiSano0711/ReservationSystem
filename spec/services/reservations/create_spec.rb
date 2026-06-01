require 'rails_helper'

RSpec.describe Services::Reservations::Create, type: :model do
  let(:current_time) { Time.zone.local(2025, 1, 1, 9, 0, 0) }

  around do |example|
    travel_to(current_time) { example.run }
  end

  describe "#call" do
    context "正常系" do
      let(:team) { create(:team) }
      let(:staff) { create(:staff, team: team) }
      let(:service_menu) { create(:service_menu, team: team) }
      let(:reservation) do
        build(:reservation, team: team, public_id: nil)
      end

      let(:service_menus) { [service_menu] }

      subject(:result) do
        described_class.new(
          reservation: reservation,
          service_menus: service_menus,
          staff: staff
        ).call
      end

      it "SuccessのResultを返す" do
        expect(result).to be_success
      end

      it "予約が作成される" do
        expect { result }.to change(Reservation, :count).by(1)
      end

      it "予約詳細が作成される" do
        expect { result }.to change(ReservationDetail, :count).by(1)
      end

      it "予約詳細とスタッフ関連が作成される" do
        expect { result }.to change(ReservationStaffAssignment, :count).by(1)
      end

      context "スタッフなし（おまかせ）の場合" do
        subject(:result) do
          described_class.new(
            reservation: reservation,
            service_menus: service_menus,
            staff: nil
          ).call
        end

        it "SuccessのResultを返す" do
          expect(result).to be_success
        end

        it "予約が作成される" do
          expect { result }.to change(Reservation, :count).by(1)
        end

        it "予約詳細が作成される" do
          expect { result }.to change(ReservationDetail, :count).by(1)
        end

        it "予約詳細とスタッフの関連は作成されない" do
          expect { result }.not_to change(ReservationStaffAssignment, :count)
        end
      end
    end

    context "失敗系" do
      let(:team) { create(:team) }
      let(:staff) { create(:staff, team: team) }
      let(:service_menu) { create(:service_menu, team: team) }
      let(:reservation) do
        build(:reservation, team: team, public_id: nil)
      end

      let(:service_menus) { [service_menu] }

      subject(:result) do
        described_class.new(
          reservation: reservation,
          service_menus: service_menus,
          staff: staff
        ).call
      end

      context "ルールのバリデーションで弾かれる場合" do
        before do
          allow_any_instance_of(Reservations::Rules::TeamBusinessSetting)
            .to receive(:validate)
            .and_return(double(invalid?: true, messages: ["ルールエラー"]))
          allow_any_instance_of(Reservations::Rules::Overlapping)
            .to receive(:validate)
            .and_return(double(invalid?: true, messages: ["ルールエラー"]))
        end

        it "FailureのResultを返す" do
          expect(result).not_to be_success
        end

        it "予約が作成されない" do
          expect { result }.not_to change(Reservation, :count)
        end
      end

      context "例外が発生した場合" do
        context "ActiveRecord::RecordInvalid" do
          before do
            allow_any_instance_of(Reservation)
              .to receive(:save!)
              .and_raise(ActiveRecord::RecordInvalid)
          end

          it "FailureのResultを返す" do
            expect(result).not_to be_success
          end

          it "予約が作成されない" do
            expect { result }.not_to change(Reservation, :count)
          end
        end

        context "ActiveRecord::NotNullViolation" do
          before do
            allow_any_instance_of(Reservation)
              .to receive(:save!)
              .and_raise(ActiveRecord::NotNullViolation)
          end

          it "FailureのResultを返す" do
            expect(result).not_to be_success
          end

          it "予約が作成されない" do
            expect { result }.not_to change(Reservation, :count)
          end
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Services::Reservations::Cancel, type: :model do
  let(:current_time) { Time.zone.local(2025, 1, 1, 9, 0, 0) }

  around do |example|
    travel_to(current_time) { example.run }
  end

  describe "#call" do
    context "正常系" do
      let(:team) { create(:team) }
      let(:reservation) { create(:reservation, team: team, status: :finalized) }

      before do
        allow_any_instance_of(Reservations::Rules::CancelPolicy)
          .to receive(:validate)
          .and_return(double(invalid?: false))
      end

      subject(:result) do
        described_class.new(
          reservation: reservation,
          actor: :customer
        ).call
      end

      it "SuccessのResultを返す" do
        expect(result).to be_success
      end

      it "予約がキャンセル済みになる" do
        result
        expect(reservation.reload.status).to eq("canceled")
      end

      it "ReservationStatusLogが作成される" do
        expect { result }.to change(ReservationStatusLog, :count).by(1)
      end
    end

    context "失敗系" do
      let(:team) { create(:team) }
      let(:reservation) { create(:reservation, team: team, status: :finalized) }

      subject(:result) do
        described_class.new(
          reservation: reservation,
          actor: :customer
        ).call
      end

      context "キャンセルポリシーで弾かれる場合" do
        before do
          allow_any_instance_of(Reservations::Rules::CancelPolicy)
            .to receive(:validate)
            .and_return(double(invalid?: true, messages: ["キャンセル不可"]))
        end

        it "FailureのResultを返す" do
          expect(result).not_to be_success
        end

        it "予約のステータスが変わらない" do
          result
          expect(reservation.reload.status).to eq("finalized")
        end

        it "ReservationStatusLogが作成されない" do
          expect { result }.not_to change(ReservationStatusLog, :count)
        end
      end

      context "例外が発生した場合" do
        context "ActiveRecord::RecordInvalid" do
          before do
            allow_any_instance_of(Reservations::Rules::CancelPolicy)
              .to receive(:validate)
              .and_return(double(invalid?: false))
            allow_any_instance_of(Reservation)
              .to receive(:update!)
              .and_raise(ActiveRecord::RecordInvalid)
          end

          it "FailureのResultを返す" do
            expect(result).not_to be_success
          end

          it "予約のステータスが変わらない" do
            result
            expect(reservation.reload.status).to eq("finalized")
          end
        end

        context "ActiveRecord::NotNullViolation" do
          before do
            allow_any_instance_of(Reservation)
              .to receive(:update!)
              .and_raise(ActiveRecord::NotNullViolation)
          end

          it "FailureのResultを返す" do
            expect(result).not_to be_success
          end

          it "予約のステータスが変わらない" do
            result
            expect(reservation.reload.status).to eq("finalized")
          end
        end
      end
    end
  end
end
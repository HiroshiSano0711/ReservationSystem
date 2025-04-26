require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:team) { create(:team) }
  let(:staff) { create(:staff, :with_profile, team: team) }
  let(:service_menu) { create(:service_menu, team: team) }

  before { allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date) }

  describe "GET /reservations/new" do
    it "renders the new template" do
      get reservations_path(permalink: team.permalink)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /reservations/menu_select" do
    it "redirects to select_slots when valid" do
      post reservations_menu_select_path(permalink: team.permalink), params: {
        reservations_select_menu_and_staff_form: {
          single_menu_ids: [service_menu.id],
          selected_staff: staff.id
        }
      }

      expect(response).to redirect_to(reservations_select_slots_path)
    end

    it "redirects back with errors when invalid" do
      post reservations_menu_select_path(permalink: team.permalink), params: {
        reservations_select_menu_and_staff_form: { single_menu_ids: [], selected_staff: nil }
      }

      expect(response).to redirect_to(reservations_path)
      expect(flash[:alert]).to be_present
    end

    it "redirects back with errors when no-params key" do
      post reservations_menu_select_path(permalink: team.permalink), params: {
        reservations_select_menu_and_staff_form: { invalid_key: nil }
      }

      expect(response).to redirect_to(reservations_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET /reservations/select_slots" do
    it "renders select_slots page" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)

      get reservations_select_slots_path(permalink: team.permalink)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:select_slots)
    end
  end

  describe "POST /reservations/save_slot_selection" do
    it "redirects to prior_confirmation when slot selected" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)
      allow(session_data).to receive(:selected_slot=)

      post reservations_save_slot_selection_path(permalink: team.permalink), params: {
        selected_slot: "2025-05-01 10:00"
      }

      expect(response).to redirect_to(reservations_prior_confirmation_path)
    end

    it "redirects back when no slot selected" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)

      post reservations_save_slot_selection_path(permalink: team.permalink), params: { selected_slot: nil }
      expect(response).to redirect_to(reservations_select_slots_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET /reservations/prior_confirmation" do
    it "shows prior confirmation page" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id,
        selected_slot: "2025-05-01 10:00"
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)

      get reservations_prior_confirmation_path(permalink: team.permalink)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /reservations/finalize" do
    it "creates reservation successfully" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id,
        selected_slot: "2025-05-01 10:00",
        clear_selection: nil
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)
      allow(session_data).to receive(:public_id=)
      allow_any_instance_of(Reservations::CreateService).to receive(:call).and_return(ServiceResult.new(success: true, data: Reservation.new(public_id: 'public_id')))

      post reservations_finalize_path(permalink: team.permalink), params: {
        reservations_finalization_form: {
          customer_name: "テストユーザー",
          customer_phone_number: "09012345678"
        }
      }

      expect(response).to redirect_to(reservations_complete_path(permalink: team.permalink, public_id: 'public_id'))
    end

    it "shows errors when finalization form is invalid" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id,
        selected_slot: "2025-05-01 10:00"
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)

      post reservations_finalize_path(permalink: team.permalink), params: {
        reservations_finalization_form: { customer_name: "", customer_phone_number: "" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:prior_confirmation)
    end

    it "shows errors when Reservation::CreateService return false" do
      session_data = instance_double(Reservations::SessionData,
        selected_service_menu_ids: [service_menu.id],
        selected_staff_id: staff.id,
        selected_slot: "2025-05-01 10:00"
      )
      allow(Reservations::SessionData).to receive(:new).and_return(session_data)
      allow_any_instance_of(Reservations::CreateService).to receive(:call).and_return(ServiceResult.new(success: false, data: nil, message: 'システムエラーが発生しました'))

      post reservations_finalize_path(permalink: team.permalink), params: {
        reservations_finalization_form: {
          customer_name: "テストユーザー",
          customer_phone_number: "09012345678"
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:prior_confirmation)
    end
  end

  describe "GET /reservations/complete" do
    it "return success response" do
      reservation = create(:reservation, team: team)

      get reservations_complete_path(permalink: team.permalink, public_id: reservation.public_id)

      expect(response).to have_http_status(:success)
    end
  end
end

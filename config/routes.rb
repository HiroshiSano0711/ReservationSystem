Rails.application.routes.draw do
  namespace :admin do
    get "/", to: "dashboard#index"
    resources :teams, only: %i[show edit update]
    resources :team_business_settings, only: %i[show edit update]
    resources :staffs, only: %i[index new create]
    resources :staff_profiles, only: %i[edit update], param: :staff_id
    resources :service_menus
    resources :reservations, only: [:index, :show], param: :public_id do
      patch :cancel, on: :member
    end
    get "account", to: "accounts#show"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :staffs, controllers: {
    invitations: "staffs/invitations",
    sessions: "staffs/sessions",
    passwords: "staffs/passwords"
  }

  devise_for :customers, controllers: {
    invitations: "customers/invitations",
    sessions: "customers/sessions",
    passwords: "customers/passwords"
  }

  get "customers/new", to: "customers#new"
  post "customers", to: "customers#invite"

  namespace :mypage do
    resources :reservations, only: [:index, :show], param: :public_id do
      patch :cancel, on: :member
    end
    resource :profile, only: [:edit, :update]
  end

  scope ":permalink", as: "reservations" do
    get "/", to: "reservations#new"
    post "/menu_select", to: "reservations#menu_select"
    get "/select_slots", to: "reservations#select_slots"
    post "/save_slot_selection", to: "reservations#save_slot_selection"
    get "/prior_confirmation", to: "reservations#prior_confirmation", as: "prior_confirmation"
    post "/finalize", to: "reservations#finalize", as: "finalize"
    get "/:public_id/complete", to: "reservations#complete", as: "complete"
    get  "/:public_id/reservation_signup", to: "reservations/registrations#new", as: :reservation_signup
    post "/:public_id/reservation_signup", to: "reservations/registrations#create", as: :reservation_signup_create
  end

  root to: "home#index"
end

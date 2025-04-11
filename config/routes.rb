Rails.application.routes.draw do
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :teams, only: %i[show edit update]
    resources :team_business_settings, only: %i[show edit update]
    resources :staffs, only: %i[index new create]
    resources :staff_profiles, only: %i[edit update], param: :staff_id
    resources :service_menus
    resources :reservations, except: %i[destroy]
    get 'account', to: 'accounts#show'
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :staffs, controllers: {
    invitable: 'staffs/invitations',
    sessions: 'staffs/sessions',
    passwords: 'staffs/passwords'
  }

  devise_for :customers, controllers: {
    sessions: 'customers/sessions',
    registrations: 'customers/registrations',
    confirmable: 'customers/confirmations',
    passwords: 'customers/passwords'
  }

  scope ':permalink', as: 'reservations' do
    root to: 'reservations#new', via: :get
    post '/menu_select', to: 'reservations#menu_select'
    get '/select_slots', to: 'reservations#select_slots'
    post '/temporary', to: 'reservations#temporary'
    get '/:public_id/prior_confirmation', to: 'reservations#prior_confirmation', as: 'prior_confirmation'
    patch '/:public_id', to: 'reservations#finalize', as: 'finalize'
    get '/:public_id/complete', to: 'reservations#complete', as: 'complete'
  end

  root to: 'home#index'
  get 'mypage', to: 'mypage#index'
end

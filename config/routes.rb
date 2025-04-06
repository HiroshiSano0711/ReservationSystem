Rails.application.routes.draw do
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :teams, only: %i[show edit update]
    resources :team_business_settings, only: %i[show edit update]
    resources :staffs
    resources :service_menus
    resources :reservations, except: %i[destroy]
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :staffs

  scope ':permalink', as: 'reservations' do
    root to: 'reservations#new', via: :get
    post '/', to: 'reservations#temporary'
    get '/:public_id', to: 'reservations#confirm', as: 'confirm'
    patch '/:public_id', to: 'reservations#complete', as: 'complete'
  end

  root to: 'home#index'
  get 'mypage', to: 'mypage#index'
end

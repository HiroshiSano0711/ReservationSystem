Rails.application.routes.draw do
  devise_for :users

  namespace :customer do
    root to: 'mypage#index'
    resources :reservations, param: :public_id, only: %i[new update] do
      member do
        post 'temporary'
        get 'confirm'
        get 'complete'
      end
    end
  end

  namespace :admin do
    root to: 'dashboard#index'
    resources :teams, only: %i[show edit update]
    resources :team_business_settings, only: %i[show edit update]
    resources :users
    resources :service_menus
    resources :reservations, except: %i[destroy]
  end

  # 未ログインユーザー用のルート。
  root to: 'home#index'
end

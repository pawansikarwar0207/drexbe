Rails.application.routes.draw do
   devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      omniauth_callbacks: 'users/omniauth_callbacks'
    }

  root 'home#index'

  devise_scope :user do
    get 'user_profile', to: 'users/registrations#show', as: :user_profile
  end
  
end

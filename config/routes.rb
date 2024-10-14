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
    get 'edit_profile_picture', to: 'users/registrations#edit_profile_picture', as: :edit_profile_picture
    patch 'update_profile_picture', to: 'users/registrations#update_profile_picture', as: :update_profile_picture

    get 'verify_document', to: 'users/registrations#verify_document', as: :verify_document
    get 'upload_passport', to: 'users/registrations#upload_passport', as: :upload_passport
    get 'upload_identity_card', to: 'users/registrations#upload_identity_card', as: :upload_identity_card
    patch 'update_passport', to: 'users/registrations#update_passport', as: :update_passport
    patch 'update_identity_card', to: 'users/registrations#update_identity_card', as: :update_identity_card
    delete 'remove_passport', to: 'users/registrations#remove_passport', as: :remove_passport
    delete 'remove_identity_card', to: 'users/registrations#remove_identity_card', as: :remove_identity_card
  end

  # get 'search_travelers', to: 'search#index'

  resources :travelers, only: [:index] do
    collection do
      get 'search', to: 'travelers#search'
    end
  end

  resources :parcel_ads
  
end

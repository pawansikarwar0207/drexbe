Rails.application.routes.draw do
  get 'chat_rooms/index'
  get 'chat_rooms/show'
  get 'chat_users/create'
  get 'messages/create'
  get 'chats/show'
  get 'users/show'
  get 'phone_verifications/new'
  get 'phone_verifications/verify'
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

  # get 'special_instruction', to: 'special_instruction#travelers'

  resources :travelers do
    collection do
      get 'search', to: 'travelers#search'
    end
    member do
      get :special_instruction  # This route is for GET request to display special instructions form
      patch :update_special_instruction  # This will handle the form submission for special instructions
    end
  end


  resources :parcel_ads do
    member do
      post :create_shipment
      post :purchase_label
      get :choose_rate
      get :email_preview
      post :create_payment_intent
      post :confirm_payment
    end
  end
 
  resource :phone_verification, only: [:show] do
    post 'verify', to: 'phone_verifications#verify_code', as: 'verify_code'
    get 'send_verification_code', to: 'phone_verifications#send_verification_code'
  end

  resources :buy_for_mes

  resources :users do
    resources :reviews, only: [:create, :new, :index, :destroy]
  end

  get 'get_cities', to: 'home#get_cities'
  get '/search_results', to: 'home#search_results'
  get '/filter_search_results', to: 'home#filter_search_results'
  get 'how_it_works', to: 'home#how_it_works'
  get 'sender_works', to: 'home#sender_works'
  get 'buyer_works', to: 'home#buyer_works'
  get 'privacy_policy', to: 'home#privacy_policy'

  get 'track/:tracking_number', to: 'tracking#show', as: :track

  resources :chat_rooms, only: [:index, :show] do
    resources :messages, only: [:create] do
      member do
        post :react
      end
      collection do
        post :mark_as_read
      end
    end
  end
end


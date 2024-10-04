# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def google_oauth2
   handle_auth "Google"
   # user = User.from_omniauth(auth)

   # if user.present?
   #  sign_out_all_scopes
   #  flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
   #  sign_in_and_redirect user, event: :authentication
   # else
   #  flash[:alert] = t 'devise.omniauth_callbacks.failuer', kind: 'Google', reason: "#{auth.info.email} is not authorized."
   #  redirect_to new_user_session_path
   #end
  end

 def handle_auth(kind)
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.present?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.auth_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  # private 

  # def auth
  #   @auth ||= request.env['omniauth.auth'] 
  # end
end

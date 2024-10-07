# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def show
    @user = current_user  # Fetch the currently logged-in user
  end

  def edit_profile_picture
    @user = current_user
  end

  def update_profile_picture
    @user = current_user
    if @user.update(profile_picture_params)
      redirect_to user_profile_path, notice: 'Profile picture updated successfully.'
    else
      render :edit_profile_picture
    end
  end

  def verify_document
    @user = current_user
  end

  def upload_passport
    @user = current_user
  end

  def upload_identity_card
    @user = current_user
  end

  def update_passport
    @user = current_user
    if @user.update(passport_document_params)
      redirect_to user_profile_path(@user), notice: 'Passport uploaded successfully.'
    else
      render :upload_passport
    end
  end

  def update_identity_card
    @user = current_user
    if @user.update(identity_card_document_params)
      redirect_to user_profile_path(@user), notice: 'Identity card uploaded successfully.'
    else
      render :upload_identity_card
    end
  end

  def remove_passport
    @user = current_user
    if @user.passport_document.attached?
      @user.passport_document.purge  # Removes the attached document
      redirect_to user_profile_path(@user), notice: 'Passport removed successfully.'
    else
      redirect_to user_profile_path(@user), alert: 'No passport found to remove.'
    end
  end

  def remove_identity_card
    @user = current_user
    if @user.identity_card_document.attached?
      @user.identity_card_document.purge  # Removes the attached document
      redirect_to user_profile_path(@user), notice: 'Identity card removed successfully.'
    else
      redirect_to user_profile_path(@user), alert: 'No identity card found to remove.'
    end
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def profile_picture_params
    params.require(:user).permit(:profile_picture)
  end

  def passport_document_params
    params.require(:user).permit(:passport_document)
  end

  def identity_card_document_params
    params.require(:user).permit(:identity_card_document)
  end

  def after_update_path_for(resource)
    user_profile_path(resource)  # Redirect to the show action
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :city, :country, :postal_code, :profile_picture])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :city, :country, :postal_code, :profile_picture])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

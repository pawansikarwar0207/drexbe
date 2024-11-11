class PhoneVerificationsController < ApplicationController
  before_action :authenticate_user!


  # Send verification code to the user's phone
  def send_verification_code
    @user = current_user

    # Check if the user has a phone number
    if @user.phone_number.blank?
      flash[:alert] = "Phone number is required to send a verification code."
      redirect_to user_profile_path  # or wherever you want to redirect
      return
    end

    # Generate a random 6-digit code
    verification_code = rand(100000..999999).to_s

    # Store the code in the user's record
    @user.update(verification_code: verification_code)

    # Send the verification code via Twilio SMS
    # send_sms(@user.phone_number, "Your verification code is #{verification_code}")

    sms_service = TwilioSmsService.new
    if sms_service.send_sms(@user.phone_number, "Your verification code is #{verification_code}")
      redirect_to phone_verification_path, notice: 'A verification code has been sent to your phone.'
    else
      flash[:alert] = 'Failed to send verification code. Please try again.'
      redirect_to user_profile_path
    end
  end

  # Show the verification form to enter the code
  def show
    @user = current_user
  end

  # Verify the code entered by the user
  def verify_code
    @user = current_user
    if @user.verification_code == params[:verification_code]
      @user.update(phone_verified: true, verification_code: nil)
      redirect_to root_path, notice: 'Your phone number has been verified successfully.'
    else
      flash[:alert] = 'Invalid verification code.'
      render :show
    end
  end

  private

  # Send SMS via Twilio
  # def send_sms(phone_number, body)
  #   require 'twilio-ruby'

  #   # Your Twilio credentials
  #   account_sid = ENV['TWILIO_ACCOUNT_SID']
  #   auth_token = ENV['TWILIO_AUTH_TOKEN']
  #   twilio_number = ENV['TWILIO_PHONE_NUMBER']

  #   # Initialize the Twilio client
  #   client = Twilio::REST::Client.new(account_sid, auth_token)

  #   # Send the message
  #   client.messages.create(
  #     from: twilio_number,
  #     to: phone_number,
  #     body: body
  #   )
  # end
end

# app/services/twilio_service.rb
require 'twilio-ruby'

class TwilioService
  def initialize
    @account_sid = Rails.application.credentials.twilio[:account_sid]
    @auth_token = Rails.application.credentials.twilio[:auth_token]
    @twilio_number = Rails.application.credentials.twilio[:phone_number]
  end

  def send_sms(to:, body:)
    # Set up the Twilio client
    client = Twilio::REST::Client.new(@account_sid, @auth_token)

    # Send the message
    message = client.messages.create(
      from: @twilio_number,
      to: to,
      body: body
    )

    message.sid  # Return the SID of the message
  rescue StandardError => e
    Rails.logger.error("Twilio error: #{e.message}")
    nil  # Return nil if there's an error
  end
end

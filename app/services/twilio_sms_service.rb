# app/services/twilio_sms_service.rb
require 'twilio-ruby'

class TwilioSmsService
  def initialize
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    @twilio_number = ENV['TWILIO_PHONE_NUMBER']
  end

  def send_sms(phone_number, body)
    @client.messages.create(
      from: @twilio_number,
      to: phone_number,
      body: body
    )
  rescue Twilio::REST::TwilioError => e
    Rails.logger.error("Twilio Error: #{e.message}")
    false
  end
end

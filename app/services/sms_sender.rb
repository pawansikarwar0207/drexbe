class SmsSender
  def self.send(to:, message:)
    Rails.logger.info "📲 Sending SMS to #{to}: #{message}"
    # Integrate with Twilio, Vonage, etc. later
  end
end

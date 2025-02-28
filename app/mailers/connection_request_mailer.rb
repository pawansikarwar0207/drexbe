class ConnectionRequestMailer < ApplicationMailer
  default from: "notifications@example.com"  # Change this to your sender email

  def request_notification(request)
    @receiver = request.receiver
    @sender = request.sender
    @request = request

    mail(to: @receiver.email, subject: "New Connection Request from #{@sender.full_name}")
  end
end

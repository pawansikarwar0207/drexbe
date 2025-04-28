class ParcelTrackingMailer < ApplicationMailer
	after_action :log_sent_email, only: [:status_changed]

	def status_changed(parcel_ad)
		@parcel_ad = parcel_ad
    status = parcel_ad.tracking_status&.humanize || 'Unknown'
	  @message = "Parcel #{parcel_ad.tracking_number} is now #{status}."
	  mail(to: parcel_ad.parcel_receiver_email, subject: "Your parcel status has changed")
  end

  private

	def log_sent_email
	  SentNotification.create!(
	    parcel_ad: @parcel_ad,
	    subject: mail.subject,
	    body: mail.body.decoded,
	    recipient: mail.to&.first,
	    sent_at: Time.current
	  )
	end
end

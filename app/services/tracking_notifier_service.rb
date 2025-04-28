class TrackingNotifierService
  def self.call(parcel_ad)
    new(parcel_ad).notify
  end

  def initialize(parcel_ad)
    @parcel_ad = parcel_ad
  end

  def notify
    send_email_notification
    send_sms_notification
  end

  private

  def send_email_notification
    ParcelTrackingMailer.status_changed(@parcel_ad).deliver_later
  end

  def send_sms_notification
    SmsSender.send(
      to: @parcel_ad.parcel_receiver_phone,
      message: "Parcel #{@parcel_ad.tracking_number} is now #{@parcel_ad.tracking_status.humanize}."
    )
  end
end

class TrackingEvent < ApplicationRecord
  belongs_to :parcel_ad
  enum status: ParcelAd.tracking_statuses
end

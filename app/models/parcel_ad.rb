class ParcelAd < ApplicationRecord
  belongs_to :user

  has_one_attached :photo

  validates :departure_city, :arrival_city, :send_date, :parcel_type, :parcel_weight, :parcel_dimension, :description, presence: true
end

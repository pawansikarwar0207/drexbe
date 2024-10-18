class ParcelAd < ApplicationRecord
  belongs_to :user

  has_many_attached :parcel_images

  validates :departure_city, :departure_country, :arrival_city, :arrival_country, :parcel_type, :parcel_quantity, presence: true
  validates :parcel_length, :parcel_width, :parcel_height, :parcel_weight, 
            numericality: { greater_than_or_equal_to: 0, 
                            message: "must be greater than or equal to 0" }
  validates :recommended_fee, :proposed_fee, 
            numericality: { greater_than_or_equal_to: 0, 
                            message: "must be greater than or equal to 0" }, 
            allow_nil: true
  validate :valid_country_codes

  # Method to calculate total parcel volume
  def parcel_volume
    parcel_length * parcel_width * parcel_height
  end

  private

  def valid_country_codes
    unless ISO3166::Country[departure_country] && ISO3166::Country[arrival_country]
      errors.add(:departure_country, 'must be a valid country')
      errors.add(:arrival_country, 'must be a valid country')
    end
  end

end


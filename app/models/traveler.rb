class Traveler < ApplicationRecord
  belongs_to :user, optional: true

  enum trip_type: { one_way: 'one_way', round_trip: 'round_trip' }
  enum transportation: { flight: 'flight', car: 'car', bus: 'bus', train: 'train', van: 'van', ship: 'ship' }

  # validates :trip_type, :departure_country, :departure_city, :arrival_country, :arrival_city, :travel_date, :travel_return_date, :parcel_type, :transportation, presence: true
  
  validates :parcel_qty, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :professionals_only, -> { joins(:user).where(users: { user_type: 'professional' }) }

end

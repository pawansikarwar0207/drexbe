class Traveler < ApplicationRecord
  belongs_to :user, optional: true

  enum trip_type: { one_way: 'one_way', round_trip: 'round_trip' }
  enum transportation: { flight: 'flight', car: 'car', bus: 'bus', train: 'train', van: 'van', ship: 'ship' }

  validates :travel_date,
            :trip_type,
            :departure_city,
            :arrival_city,
            :transportation,
            :parcel_type, 
            :special_instructions,
            :parcel_weight,
            :travel_time,
            :buy_for_you,
            presence: true
            # :parcel_qty,
            # :ready_to_buy_for_you,
            # :parcel_collection_mode,

  # validates :parcel_qty, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :travel_return_date, presence: true, if: :round_trip?
  
  scope :professionals_only, -> { joins(:user).where(users: { user_type: 'professional' }) }
  
  def self.ransackable_attributes(auth_object = nil)
    ["arrival_city", "arrival_country", "created_at", "departure_city", "departure_country", "email", "id", "name", "parcel_collection_mode", "parcel_qty", "parcel_type", "ready_to_buy_for_you", "transportation", "travel_date", "travel_return_date", "trip_type", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  private

  def round_trip?
    trip_type == 'round_trip'
  end

end

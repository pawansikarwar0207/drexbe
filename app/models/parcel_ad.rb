class ParcelAd < ApplicationRecord
  belongs_to :user

  has_many_attached :parcel_images

  # validates :departure_city, :departure_country, :arrival_city, :arrival_country, :parcel_type, :parcel_quantity, presence: true

  validates :parcel_length, :parcel_width, :parcel_height, :parcel_weight, 
            numericality: { greater_than_or_equal_to: 0, 
                            message: "must be greater than or equal to 0" },
                            if: :requires_dimensions?

  validates :recommended_fee, :proposed_fee, 
            numericality: { greater_than_or_equal_to: 0, 
                            message: "must be greater than or equal to 0" }, 
            allow_nil: true

  scope :by_professionals, -> { joins(:user).where(users: { user_type: 'professional' }) }

  def calculate_cost
    base_rate = 10
    total_cost = parcel_weight.to_f * base_rate
    total_cost
  end
  
  private

  def requires_dimensions?
    parcel_type != 'Document'
  end

end



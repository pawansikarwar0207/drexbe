require 'shippo'

class ParcelAd < ApplicationRecord
  enum tracking_status: {
    pending: 0,
    confirmed: 1,
    in_transit: 2,
    out_for_delivery: 3,
    delivered: 4,
    cancelled: 5
  }

  before_create :generate_tracking_number
  after_update :send_status_change_notification, if: :saved_change_to_tracking_status?
  after_update :record_tracking_event, if: :saved_change_to_tracking_status?

  belongs_to :user

  has_many :tracking_events, dependent: :destroy

  has_many_attached :parcel_images

  validates :departure_city, :arrival_city, :parcel_type, :parcel_weight, :parcel_quantity, :proposed_fee, :shipment_date, presence: true

  validates :parcel_length, :parcel_width, :parcel_height, 
            numericality: { greater_than_or_equal_to: 0, 
                            message: "must be greater than or equal to 0" },
                            if: :requires_dimensions?

  validates  :proposed_fee, 
            numericality: { greater_than_or_equal_to: 0, 
                            message: "must be greater than or equal to 0" }, 
            allow_nil: true

  scope :by_professionals, -> { joins(:user).where(users: { user_type: 'professional' }) }


  def calculate_cost
    base_rate = 10
    total_cost = parcel_weight.to_f * base_rate
    total_cost
  end

  def self.ransackable_attributes(auth_object = nil)
    ["arrival_city", "arrival_country", "bonus", "created_at", "departure_city", "departure_country", "description", "id", "insure_shipment", "label_url", "parcel_height", "parcel_length", "parcel_quantity", "parcel_type", "parcel_weight", "parcel_width", "proposed_fee", "rate_id", "recommended_fee", "service_type", "shipment_date", "shipment_id", "updated_at", "user_id"]
  end

  def record_tracking_event
    tracking_events.create!(
      status: tracking_status,
      description: "Status changed to #{tracking_status.humanize}",
      occurred_at: Time.current
    )
  end
  
  private

  def generate_tracking_number
    self.tracking_number = "TRK-#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(3).upcase}"
  end

  def send_status_change_notification
    TrackingNotifierService.call(self)
  end

  def requires_dimensions?
    parcel_type != 'Document'
  end

  # def create_shipment
  #   shipment = Shippo::Shipment.create(
  #     address_from: {
  #       name: user.full_name,
  #       street1: user.address_1,
  #       city: departure_city,
  #       state: departure_country,
  #       zip: user.postal_code,
  #       country: user.country,
  #       email: user.email
  #     },
  #     address_to: {
  #       name: "Recipient Name",
  #       street1: "Recipient Address",
  #       city: arrival_city,
  #       state: arrival_country,
  #       zip: "Recipient Postal Code",
  #       country: arrival_country,
  #       email: "recipient@example.com"
  #     },
  #     parcels: [{
  #       length: parcel_length,
  #       width: parcel_width,
  #       height: parcel_height,
  #       distance_unit: 'in', # adjust based on Shippo's requirements
  #       weight: parcel_weight,
  #       mass_unit: 'lb' # adjust based on Shippo's requirements
  #     }],
  #     async: false
  #   )

  #   shipment
  # end

  def purchase_label
    # Replace with your actual address details or fetch from related data
    address_from = {
      name: "Sender Name",
      street1: "123 Sender St",
      city: "Bhopal",
      state: "",
      zip: "462001",
      country: "IN",
      phone: "1234567890",
      email: "sender@example.com"
    }

    address_to = {
      name: "Receiver Name",
      street1: "456 Receiver Ave",
      city: "Pune",
      state: "",
      zip: "411001",
      country: "IN",
      phone: "0987654321",
      email: "receiver@example.com"
    }

    # Parcel details, typically from your `ParcelAd` model fields
    parcel = {
      length: self.parcel_length,
      width: self.parcel_width,
      height: self.parcel_height,
      distance_unit: "in",
      weight: self.parcel_weight,
      mass_unit: "lb"
    }

    # Create shipment with Shippo
    shipment = Shippo::Shipment.create(
      address_from: address_from,
      address_to: address_to,
      parcels: [parcel],
      async: false
    )

    if shipment["status"] == "SUCCESS"
      # Fetch rates and select the preferred one (e.g., the lowest rate)
      rate = shipment["rates"].min_by { |r| r["amount"].to_f }
      
      # Purchase the label with the selected rate
      label = Shippo::Transaction.create(
        rate: rate["object_id"],
        label_file_type: "PDF", # Or "PNG" if preferred
        async: false
      )

      if label["status"] == "SUCCESS"
        # Return label details, such as the label URL
        {
          status: "SUCCESS",
          label_url: label["label_url"],
          tracking_number: label["tracking_number"]
        }
      else
        { status: "FAILED", error: label["messages"] }
      end
    else
      { status: "FAILED", error: shipment["messages"] }
    end
  rescue => e
    # Handle API errors and return failure response
    { status: "ERROR", error: e.message }
  end

  # Only calculate if all parcel details are present
  def fee_required?
    parcel_length.present? && parcel_width.present? && parcel_height.present? && parcel_weight.present?
  end

  # Compare proposed fee with recommended fee
  def fee_difference
    if proposed_fee.present? && recommended_fee.present?
      (proposed_fee.to_f - recommended_fee.to_f).round(2)
    else
      nil
    end
  end

end



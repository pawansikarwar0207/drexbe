require 'shippo'

class ShipmentService
  def initialize
    # Initialize the Shippo API with your API key
    Shippo::API.token = Rails.application.credentials.dig(:shippo, :api_key) || ENV['SHIPPO_API_KEY']
  end

  def create_shipment(parcel_ad)
    shipment_params = {
      address_from: {
        city: parcel_ad.departure_city,
        country: parcel_ad.departure_country
      },
      address_to: {
        city: parcel_ad.arrival_city,
        country: parcel_ad.arrival_country
      },
      parcels: [
        {
          length: parcel_ad.parcel_length.to_f,
          width: parcel_ad.parcel_width.to_f,
          height: parcel_ad.parcel_height.to_f,
          distance_unit: "in",
          weight: parcel_ad.parcel_weight.to_f,
          mass_unit: "lb"
        }
      ],
      shipment_date: parcel_ad.shipment_date.to_time.iso8601
    }

    Shippo::Shipment.create(shipment_params)
  end

  def purchase_label(rate_id)
    # Purchase the label using the stored rate ID
    transaction = Shippo::Transaction.create(
      rate: rate_id,
      label_file_type: "PDF"
    )

    # Return the transaction result with label URL if successful
    if transaction.status == "SUCCESS"
      OpenStruct.new(success?: true, label_url: transaction.label_url)
    else
      OpenStruct.new(success?: false, error_message: transaction.messages.first["text"])
    end
  rescue Shippo::Exceptions::ConnectionError => e
    OpenStruct.new(success?: false, error_message: "Connection error: #{e.message}")
  rescue Shippo::Exceptions::APIServerError => e
    OpenStruct.new(success?: false, error_message: "Shippo server error: #{e.message}")
  end
end

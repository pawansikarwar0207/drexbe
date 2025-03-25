require 'shippo'

class ShippoService
  def initialize
    @api_key = ENV['SHIPPO_API_KEY']
    Shippo::API.token = @api_key
  end

  # Create shipment and fetch rates
  def create_shipment(parcel_ad)
    shipment = Shippo::Shipment.create(
      address_from: build_address_from(parcel_ad),
      address_to: build_address_to(parcel_ad),
      parcels: [build_parcel(parcel_ad)],
      async: false
    )

    shipment
  end

  # Purchase label using shipment_id
  def purchase_label(shipment_id)
    transaction = Shippo::Transaction.create(
      rate: shipment_id,
      label_file_type: 'PDF'
    )

    if transaction[:status] == 'SUCCESS'
      OpenStruct.new(success?: true, label_url: transaction[:label_url])
    else
      OpenStruct.new(success?: false, error_message: transaction[:messages])
    end
  end

  private

  # Build sender's address
  def build_address_from(parcel_ad)
    {
      object_purpose: 'PURCHASE',
      name: 'Sender Name',
      street1: '123 Main St',
      city: parcel_ad.departure_city,
      state: '',
      zip: '94117',
      country: parcel_ad.departure_country,
      phone: '415-555-5555',
      email: 'sender@example.com'
    }
  end

  # Build recipient's address
  def build_address_to(parcel_ad)
    {
      object_purpose: 'PURCHASE',
      name: 'Recipient Name',
      street1: '456 Elm St',
      city: parcel_ad.arrival_city,
      state: '',
      zip: '10001',
      country: parcel_ad.arrival_country,
      phone: '212-555-5555',
      email: 'recipient@example.com'
    }
  end

  # Build parcel details
  def build_parcel(parcel_ad)
    {
      length: parcel_ad.parcel_length.to_f,
      width: parcel_ad.parcel_width.to_f,
      height: parcel_ad.parcel_height.to_f,
      distance_unit: 'in',
      weight: parcel_ad.parcel_weight.to_f,
      mass_unit: 'lb'
    }
  end
end

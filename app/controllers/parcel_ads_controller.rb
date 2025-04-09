require 'net/http'
require 'json'

class ParcelAdsController < ApplicationController
	# before_action :authenticate_user!
	# before_action :check_professional_user, only: [:new, :create]

	def index
		@parcel_ads = ParcelAd.all.order(created_at: :desc)
	end

	def new
		@parcel_ad = ParcelAd.new
	end

	def create
	  if user_signed_in? # Check if the user is signed in
	    @parcel_ad = current_user.parcel_ads.build(parcel_ad_params)
	    if @parcel_ad.save
	      # redirect_to parcel_ads_path, notice: "Your ad has been successfully published."
	      fetch_and_update_rates(@parcel_ad)
				respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @parcel_ad, notice: "Your request has been successfully created." }
        end
	    else
	      # render :new, status: :unprocessable_entity
				respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("form-errors", partial: "parcel_ads/parcel_form_errors", locals: { object: @parcel_ad }) }
          format.html { render :new, status: :unprocessable_entity }
        end
	    end
	  else
	    redirect_to new_user_session_path, alert: "You need to sign in to create a parcel ad."
	  end
	end


	def show
		@parcel_ad = ParcelAd.find(params[:id])
		@comparison_result = compare_fees(@parcel_ad.proposed_fee, @parcel_ad.recommended_fee)
	end

	def edit
		@parcel_ad = ParcelAd.find(params[:id])
	end

	def update
		@parcel_ad = ParcelAd.find(params[:id])
		if @parcel_ad.update(parcel_ad_params)
			redirect_to parcel_ads_path, notice: "Your add has been successfully updated."
		else
			render :edit, alert: "Something went wrong."
		end
	end

	def get_cities
    country_code = params[:country]
    cities = get_cities_by_country(country_code)

    render json: { cities: cities }
  end

  #create the shipment with shippo api
  def create_shipment
	  @parcel_ad = ParcelAd.find(params[:id])
	  shipment_service = ShipmentService.new

	  address_from = {
      name: @parcel_ad.parcel_sender_name,
		  street1: @parcel_ad.address_from_street1,
		  street2: @parcel_ad.address_from_street2.presence,
		  city: @parcel_ad.departure_city,
		  state: @parcel_ad.address_from_state,
		  zip: @parcel_ad.address_from_zip,
		  country: @parcel_ad.departure_country,
		  phone: @parcel_ad.parcel_sender_phone,
		  email: @parcel_ad.parcel_sender_email,
		  is_residential: @parcel_ad.address_from_is_residential

    }

    address_to = {
      name: @parcel_ad.parcel_receiver_name,
		  street1: @parcel_ad.address_to_street1,
		  street2: @parcel_ad.address_to_street2.presence,
		  city: @parcel_ad.arrival_city,
		  state: @parcel_ad.address_to_state,
		  zip: @parcel_ad.address_to_zip,
		  country: @parcel_ad.arrival_country,
		  phone: @parcel_ad.parcel_receiver_phone,
		  email: @parcel_ad.parcel_receiver_email,
		  is_residential: @parcel_ad.address_to_is_residential
    }

    parcel = {
		  length: @parcel_ad.parcel_length,
		  width: @parcel_ad.parcel_width,
		  height: @parcel_ad.parcel_height,
		  distance_unit: "in",
		  weight: @parcel_ad.parcel_weight,
		  mass_unit: "lb"
		}

    begin
	    # Create shipment via Shippo API
	    raw_shipment = Shippo::Shipment.create(
	      address_from: address_from,
	      address_to: address_to,
	      parcels: [parcel],
	      async: false
	    )

	    # Filter supported carriers
	  #   supported_carriers = ['USPS', 'UPS'] # <- adjust this as needed

	  #   # Filter rates from supported carriers only and with no error messages
	  #   filtered_rates = raw_shipment.rates.select do |rate|
	  #     supported_carriers.include?(rate['provider']) && rate['messages'].blank?
	  #   end

	  #   if filtered_rates.present?
	  #     @shipment_id = raw_shipment['object_id']
	  #     @rate_id = filtered_rates.first['object_id'] # Choose first valid rate

	  #     # Save to ParcelAd
	  #     @parcel_ad.update(shipment_id: @shipment_id, rate_id: @rate_id)
	  #     flash[:notice] = "Shipment created and filtered rates applied successfully."
	  #   else
	  #     flash[:alert] = "Shipment created, but no supported carrier rates found. Please try a different address or package."
	  #   end

	  # rescue Shippo::Exceptions::APIServerError => e
	  #   flash[:alert] = "Failed to create shipment: #{e.message}"
	  # end

	  # redirect_to parcel_ad_path(@parcel_ad)
	  	if raw_shipment.status == 'SUCCESS'
			  @parcel_ad.update!(
			    shipment_id: raw_shipment.object_id,
			    available_rates: raw_shipment.rates.to_json
			  )
			  redirect_to choose_rate_parcel_ad_path(@parcel_ad)
			else
			  redirect_to @parcel_ad, alert: "Shipment creation failed."
			end
		end
	end


  # def purchase_label
	#   @parcel_ad = ParcelAd.find(params[:id])

	#   if @parcel_ad.rate_id.blank?
	#     flash[:alert] = "Rate ID not found. Please create a shipment first."
	#     return redirect_to parcel_ad_path(@parcel_ad)
	#   end

	#   begin
	#     transaction = Shippo::Transaction.create(
	#       rate: @parcel_ad.rate_id,
	#       label_file_type: "PDF",
	#       async: false
	#     )

	#     if transaction.status == "SUCCESS"
	#       @parcel_ad.update(
	#         label_url: transaction.label_url,
	#         tracking_number: transaction.tracking_number,
	#         tracking_url_provider: transaction.tracking_url_provider
	#       )
	#       flash[:notice] = "Label purchased successfully. You can now download and track the shipment."
	#     else
	#       error_messages = transaction.messages.map { |m| m['text'] }.join(', ')
	#       flash[:alert] = "Label purchase failed: #{error_messages}"
	#     end

	#   rescue Shippo::Exceptions::APIServerError => e
	#     flash[:alert] = "API error during label purchase: #{e.message}"
	#   end

	#   redirect_to parcel_ad_path(@parcel_ad)
	# end

	def purchase_label
	  @parcel_ad = ParcelAd.find(params[:id])
	  selected_rate_id = params[:rate_id]

	  # Use Shippo to purchase the label
	  transaction = Shippo::Transaction.create(
	    rate: selected_rate_id,
	    label_file_type: "PDF",
	    async: false
	  )

	  if transaction.status == "SUCCESS"
	    @parcel_ad.update!(
	      label_url: transaction.label_url,
	      tracking_number: transaction.tracking_number,
	      tracking_url_provider: transaction.tracking_url_provider,
	      rate_id: selected_rate_id
	    )
	    redirect_to @parcel_ad, notice: "Label purchased successfully."
	  else
	    redirect_to choose_rate_parcel_ad_path(@parcel_ad), alert: "Failed to purchase label."
	  end
	end


	# parcel_ads_controller.rb
	def choose_rate
	  @parcel_ad = ParcelAd.find(params[:id])

	  if @parcel_ad.available_rates.present?
	    @rates = JSON.parse(@parcel_ad.available_rates)
	  else
	    redirect_to @parcel_ad, alert: "Rates not found."
	  end
	end





  def fetch_and_update_rates(parcel_ad)
	  shipment_service = ShippoService.new
	  shipment = shipment_service.create_shipment(parcel_ad)

	  # Check if shipment and rates are available
	  if shipment && shipment['rates'].present?
	    best_rate = shipment['rates'].min_by { |rate| rate['amount'].to_f } # Get the lowest rate

	    # Update parcel_ad with recommended fee and rate ID
	    parcel_ad.update(
	      recommended_fee: best_rate['amount'].to_f,
	      rate_id: best_rate['object_id'],
	      shipment_id: shipment['object_id']
	    )
	  end
	end

	# Compare proposed and recommended fees
	def compare_fees(proposed_fee, recommended_fee)
	  if proposed_fee.to_f > recommended_fee.to_f
	    { status: 'higher', difference: (proposed_fee.to_f - recommended_fee.to_f).round(2) }
	  elsif proposed_fee.to_f < recommended_fee.to_f
	    { status: 'lower', difference: (recommended_fee.to_f - proposed_fee.to_f).round(2) }
	  else
	    { status: 'equal', difference: 0 }
	  end
	end

	private	

	# def check_professional_user
	# 	redirect_to root_path, alert: 'Only professional user can post trips.' unless current_user.professional?
	# end

	def parcel_ad_params
		params.require(:parcel_ad).permit(
			:departure_city,
			:arrival_city,
			:departure_country,
			:arrival_country,
			:shipment_date,
			:parcel_type,
			:parcel_weight,
			:parcel_length,
			:parcel_width,
			:parcel_height,
			:parcel_quantity,
			:insure_shipment,
			:description,
			:bonus,
			:service_type,
			:recommended_fee,
			:time, 
			:special_instructions,
			:proposed_fee,
			:address_from_street1,
			:address_from_street2,
			:address_from_street3,
			:address_from_state,
			:address_from_zip,
			:address_from_street_no,
			:address_from_is_residential,
			:parcel_sender_name,
			:parcel_sender_phone,
			:parcel_sender_email,
			:address_to_street1,
			:address_to_street2,
			:address_to_street3,
			:address_to_state,
			:address_to_zip,
			:address_to_street_no,
			:address_to_is_residential,
			:parcel_receiver_name,
			:parcel_receiver_phone,
			:parcel_receiver_email,
		   parcel_images: []
		)
	end

	# def get_cities_by_country(country_code)
  #   username = 'pawansikarwar'
  #   uri = URI("http://api.geonames.org/searchJSON?country=#{country_code}&featureClass=P&maxRows=1000&username=#{username}")
  #   response = Net::HTTP.get(uri)
  #   json_response = JSON.parse(response)
  #   cities = json_response['geonames'].map { |city| city['name'] }
  #   cities
  # end

  def get_cities
    query = params[:query]
    country = params[:country]

    username = 'pawansikarwar'
    uri = URI("http://api.geonames.org/searchJSON?name=#{query}&featureClass=P&maxRows=10&username=#{username}")
    uri.query += "&country=#{country}" if country.present?

    response = Net::HTTP.get(uri)
    json_response = JSON.parse(response)

    locations = json_response['geonames'].map do |location|
      {
        name: location['name'],
        area: location['adminName1'],
        country: location['countryName'],
        type: location['featureCode'],
      }
    end

    render json: { locations: locations }
  end

end

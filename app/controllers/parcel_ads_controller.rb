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
          format.html { redirect_to parcel_ads_path, notice: "Your request has been successfully created." }
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

	  begin
	    shipment = shipment_service.create_shipment(@parcel_ad)

	    # Check if the shipment and rates are present
	    if shipment && shipment['rates'].present?
	      @shipment_id = shipment['object_id']
	      @rate_id = shipment['rates'].first['object_id'] # Get the first rate ID

	      # Update the ParcelAd with shipment_id and rate_id
	      @parcel_ad.update(shipment_id: @shipment_id, rate_id: @rate_id)
	      flash[:notice] = "Shipment created successfully."
	    else
	      flash[:alert] = "Shipment created, but no rates were available. Please check the shipment details or contact support."
	    end
	  rescue Shippo::Exceptions::APIServerError => e
	    flash[:alert] = "Failed to create shipment: #{e.message}"
	  end

	  redirect_to parcel_ad_path(@parcel_ad)
	end


  def purchase_label
    @parcel_ad = ParcelAd.find(params[:id])

    # Ensure the shipment was created beforehand
    if @parcel_ad.shipment_id.present?
      shipment_service = ShipmentService.new
      result = shipment_service.purchase_label(@parcel_ad.shipment_id)

      if result.success?
        @label_url = result.label_url
        flash[:notice] = "Label purchased successfully. Download it here: #{@label_url}"
      else
        flash[:alert] = "Failed to purchase label: #{result.error_message}"
      end
    else
      flash[:alert] = "Shipment not found. Please create a shipment first."
    end

    redirect_to parcel_ad_path(@parcel_ad)
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

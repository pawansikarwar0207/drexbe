require 'net/http'
require 'json'

class ParcelAdsController < ApplicationController
	before_action :authenticate_user!

	def index
		@parcel_ads = ParcelAd.all.order(created_at: :desc)
	end

	def new
		@parcel_ad = ParcelAd.new
	end

	def create
		@parcel_ad = current_user.parcel_ads.build(parcel_ad_params)
		if @parcel_ad.save
			redirect_to parcel_ads_path, notice: "Your add has been successfully published."
		else
			Rails.logger.debug(@parcel_ad.errors.full_messages)
			render :new, alert: "Something went wrong."
		end
	end

	def show
		@parcel_ad = ParcelAd.find(params[:id])
	end

	def edit
		@parcel_ad = ParcelAd.find(params[:id])
	end

	def update
		@parcel_ad = ParcelAd.find(params[:id])
		if @parcel_ad.update(parcel_ad_params)
			redirect_to parcel_ads_path, notice: "Your add has been successfully updated."
		else
			render :new, alert: "Something went wrong."
		end
	end

	def get_cities
    country_code = params[:country]
    cities = get_cities_by_country(country_code)

    render json: { cities: cities }
  end

	private	

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

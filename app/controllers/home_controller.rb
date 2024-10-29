class HomeController < ApplicationController
  # before_action :authenticate_user!
  def index
  end

  def search_results
    travelers_conditions = {}
    parcel_ads_conditions = {}
    buy_for_me_conditions = {}

    # Only add search conditions if the parameters are present
    travelers_conditions[:departure_city] = params[:departure_city] if params[:departure_city].present?
    travelers_conditions[:departure_country] = params[:departure_country] if params[:departure_country].present?
    travelers_conditions[:arrival_city] = params[:arrival_city] if params[:arrival_city].present?
    travelers_conditions[:arrival_country] = params[:arrival_country] if params[:arrival_country].present?
    travelers_conditions[:travel_date] = params[:date] if params[:date].present?

    # Only add search conditions if the parameters are present
    parcel_ads_conditions[:departure_city] = params[:departure_city] if params[:departure_city].present?
    parcel_ads_conditions[:departure_country] = params[:departure_country] if params[:departure_country].present?
    parcel_ads_conditions[:arrival_city] = params[:arrival_city] if params[:arrival_city].present?
    parcel_ads_conditions[:arrival_country] = params[:arrival_country] if params[:arrival_country].present?

    # Only add search conditions if the parameters are present
    buy_for_me_conditions[:departure_city] = params[:departure_city] if params[:departure_city].present?
    buy_for_me_conditions[:departure_country] = params[:departure_country] if params[:departure_country].present?
    buy_for_me_conditions[:arrival_city] = params[:arrival_city] if params[:arrival_city].present?
    buy_for_me_conditions[:arrival_country] = params[:arrival_country] if params[:arrival_country].present?

    # Perform the search with the conditions
    @travelers = Traveler.where(travelers_conditions)
    @parcel_ads = ParcelAd.where(parcel_ads_conditions)
    @buy_for_mes = BuyForMe.where(buy_for_me_conditions)

    render 'search_results'
  end

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


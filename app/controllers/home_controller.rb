class HomeController < ApplicationController
  # before_action :authenticate_user!
  def index
  end

  def search_results
    # Build Ransack search objects for each model
    travelers_conditions = Traveler.ransack(
                                    departure_city_eq: params[:departure_city],
                                    departure_country_eq: params[:departure_country],
                                    arrival_city_eq: params[:arrival_city],
                                    arrival_country_eq: params[:arrival_country],
                                    travel_date_eq: params[:date],
                                    parcel_type_eq: params[:parcel_type])

    parcel_ads_conditions = ParcelAd.ransack(
                                    departure_city_eq: params[:departure_city],
                                    departure_country_eq: params[:departure_country],
                                    arrival_city_eq: params[:arrival_city],
                                    shipment_date_eq: params[:date],
                                    arrival_country_eq: params[:arrival_country],
                                    parcel_type_eq: params[:parcel_type],
                                    parcel_weight_eq: params[:parcel_weight],
                                    recommended_fee_eq: params[:recommended_fee],
                                    proposed_fee_eq: params[:proposed_fee])

    buy_for_me_conditions = BuyForMe.ransack(
                                    departure_city_eq: params[:departure_city],
                                    departure_country_eq: params[:departure_country],
                                    arrival_city_eq: params[:arrival_city],
                                    shopping_date_eq: params[:date],
                                    arrival_country_eq: params[:arrival_country],
                                    parcel_type_eq: params[:parcel_type])

    # Handle weight conditions for ParcelAds
    weight_condition = case params[:parcel_weight]
                       when '250..500' then { parcel_weight: 250..500 }
                       when '500..1000' then { parcel_weight: 500..1000 }
                       when '1000..2000' then { parcel_weight: 1000..2000 }
                       when '2000+' then { parcel_weight: 2000..Float::INFINITY }
                       else {}
                       end

    # Handle fee conditions for ParcelAds
    fee_condition = case params[:proposed_fee]
                    when '10..100' then { proposed_fee: 10..100 }
                    when '100..300' then { proposed_fee: 100..300 }
                    when '300..500' then { proposed_fee: 300..500 }
                    when '500+' then { proposed_fee: 500..Float::INFINITY }
                    else {}
                    end

    # Filter ParcelAds by weight and fee
    @parcel_ads = ParcelAd.where(weight_condition).where(fee_condition)

    # Determine results to display based on presence of weight/fee filters
    if params[:parcel_weight].present? || params[:proposed_fee].present?
      @travelers = []
      @buy_for_mes = []
    else
      @travelers = travelers_conditions.result(distinct: true)
      @parcel_ads = parcel_ads_conditions.result(distinct: true).includes(user: { profile_picture_blob: :attachments, identity_card_document_blob: :attachments })
      @buy_for_mes = buy_for_me_conditions.result(distinct: true)

      # Apply filter to limit results to one model type if specified
      filter_params = Array(params[:filter])
      case filter_params
      when ['traveler']
        @parcel_ads = []
        @buy_for_mes = []
      when ['sender']
        @travelers = []
        @buy_for_mes = []
      when ['buyer']
        @travelers = []
        @parcel_ads = []
      end
    end

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


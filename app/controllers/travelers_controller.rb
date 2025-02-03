class TravelersController < ApplicationController
  # before_action :authenticate_user!
	before_action :set_traveler, only: %i[show edit update destroy]

  def index
    @travelers = Traveler.all
  end

  def show
  end

  def new
    @traveler = Traveler.new
  end

  def create
    if user_signed_in? 
      @traveler = current_user.travelers.build(traveler_params)
      if @traveler.save
        redirect_to travelers_path, notice: 'Traveler was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_user_session_path, alert: "You need to sign in to create a parcel ad."
    end
  end

  def edit
  end

  def update
    if @traveler.update(traveler_params)
      redirect_to @traveler, notice: 'Traveler was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @traveler.destroy
    redirect_to travelers_url, notice: 'Traveler was successfully destroyed.'
  end

  def search_results
    # Retrieve search parameters
    @departure_country = params[:departure_country].presence
    @departure_city = params[:departure_city].presence
    @arrival_country = params[:arrival_country].presence
    @arrival_city = params[:arrival_city].presence
    @travel_date = params[:date].presence

    # Build query based on provided parameters
    @travelers = Traveler.all

    @travelers = @travelers.where(departure_country: @departure_country) if @departure_country
    @travelers = @travelers.where(departure_city: @departure_city) if @departure_city
    @travelers = @travelers.where(arrival_country: @arrival_country) if @arrival_country # Fix this typo
    @travelers = @travelers.where(arrival_city: @arrival_city) if @arrival_city # Fix this typo
    @travelers = @travelers.where(travel_date: @travel_date) if @travel_date

    # Execute query
    @travelers = Traveler.where(departure_country: @departure_country, departure_city: @departure_city, arrival_country: @arrival_country, arrival_city: @arrival_city, travel_date: @travel_date).presence || []
    @parcel_ads = ParcelAd.where(departure_country: @departure_country, departure_city: @departure_city, arrival_country: @arrival_country, arrival_city: @arrival_city).presence || []
    @buy_for_me = BuyForMe.where(departure_country: @departure_country, departure_city: @departure_city, arrival_country: @arrival_country, arrival_city: @arrival_city).presence || []
  end

  def special_instruction
    @traveler = Traveler.find(params[:id])
  end

  def update_special_instruction
    @traveler = Traveler.find(params[:id])
    if @traveler.update(traveler_params)
      redirect_to travelers_path, notice: 'Special instructions successfully updated.'
    else
      render :special_instruction
    end
  end

  private

  def get_cities_by_country(country_code)
    username = 'pawansikarwar'
    uri = URI("http://api.geonames.org/searchJSON?country=#{country_code}&featureClass=P&maxRows=1000&username=#{username}")
    response = Net::HTTP.get(uri)
    json_response = JSON.parse(response)
    cities = json_response['geonames'].map { |city| city['name'] }
    cities
  end

  def set_traveler
    @traveler = Traveler.find(params[:id])
  end

  def traveler_params
    params.require(:traveler).permit(:trip_type, :departure_country, :departure_city, :arrival_country, :arrival_city, :travel_date, :transportation, :parcel_type, :parcel_qty, :ready_to_buy_for_you, :parcel_collection_mode, :travel_return_date, :travel_time, :special_instructions, :parcel_weight, :buy_for_you)
  end
end


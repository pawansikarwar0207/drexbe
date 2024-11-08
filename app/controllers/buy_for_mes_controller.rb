class BuyForMesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_buy_for_me, only: %i[show edit update]

  def index
  	@buy_for_mes = BuyForMe.all
  end

  def new
    @buy_for_me = BuyForMe.new
  end

  def create
    @buy_for_me = BuyForMe.new(buy_for_me_params)
    if @buy_for_me.save
      redirect_to buy_for_mes_path, notice: "Your 'Buy for Me' request has been successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
     if @buy_for_me.update(buy_for_me_params)
      redirect_to buy_for_mes_path, notice: "Your 'Buy for Me' request has been successfully updated."
    else
      render :edit, alert: 'Something went wrong.'
    end
  end

  def show
	end

  private

  def set_buy_for_me
    @buy_for_me = BuyForMe.find(params[:id])
  end

  def get_cities_by_country(country_code)
    username = 'pawansikarwar'
    uri = URI("http://api.geonames.org/searchJSON?country=#{country_code}&featureClass=P&maxRows=1000&username=#{username}")
    response = Net::HTTP.get(uri)
    json_response = JSON.parse(response)
    cities = json_response['geonames'].map { |city| city['name'] }
    cities
  end

  def buy_for_me_params
    params.require(:buy_for_me).permit(
      :departure_country,
      :departure_city,
      :arrival_country,
      :arrival_city,
      :shopping_date,
      :product_link,
      :shop_name, 
      :shop_address,
      :category,
      :product_name,
      :product_quantity,
      :parcel_type,
      :product_price,
      :buy_for_me_fee,
      :total_price
    )
  end
end

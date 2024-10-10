class TravelersController < ApplicationController
	def index
    @travelers = Traveler.all
  end

  def search
    @travelers = Traveler.all

    @travelers = @travelers.where(from_city: params[:from_city]) if params[:from_city].present?
    @travelers = @travelers.where(to_city: params[:to_city]) if params[:to_city].present?
    @travelers = @travelers.where(travel_date: params[:travel_date]) if params[:travel_date].present?
    
    render :index
  end
end

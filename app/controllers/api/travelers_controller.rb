class Api::TravelersController < ApplicationController
  def index
    @travelers = Traveler.includes(:user).where.not(departure_city: nil, arrival_city: nil)
    render json: @travelers.map { |t|
      {
        id: t.id,
        name: t.name,
        departure_city: "#{t.departure_city}, #{t.departure_country}",
        arrival_city: "#{t.arrival_city}, #{t.arrival_country}",
        travel_date: t.travel_date,
        return_date: t.travel_return_date
      }
    }
  end
end

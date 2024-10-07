class SearchController < ApplicationController
  def index
    @country = params[:country]
    @city = params[:city]
    @airport = params[:airport]
    @date = params[:travel_date].presence
    @type = params[:type]

    if @type == 'Traveler'
      @results = Traveler.all

      # Apply filters
      @results = @results.where(city: @city) if @city.present?
      @results = @results.where(country: @country) if @country.present?
      @results = @results.where(airport: @airport) if @airport.present?
      
      # Optional: Only filter by travel_date if provided
      @results = @results.where('travel_date >= ?', @date) if @date.present?
      
    elsif @type == 'Send Package' || @type == 'Buy Item'
      announcement_type = @type.downcase.tr(' ', '_')
      @results = Announcement.where(announcement_type: announcement_type)

      # Apply filters
      @results = @results.where(country: @country) if @country.present?
      @results = @results.where(city: @city) if @city.present?
      @results = @results.where('date >= ?', @date) if @date.present?
    else
      @results = []
    end
  end
end

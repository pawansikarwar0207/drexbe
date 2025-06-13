class GeocodeController < ApplicationController
  def search
    query = params[:q]
    if query.blank?
      render json: { error: "Missing query" }, status: :bad_request and return
    end

    uri = URI("https://nominatim.openstreetmap.org/search")
    uri.query = URI.encode_www_form({
      q: query,
      format: "json",
      addressdetails: 1,
      limit: 1
    })

    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      render json: JSON.parse(response.body)
    else
      Rails.logger.error "Nominatim error: #{response.code} #{response.body}"
      render json: { error: "Geocoding failed", message: "Nominatim error" }, status: :internal_server_error
    end
  rescue => e
    Rails.logger.error "Geocoding exception: #{e.message}"
    render json: { error: "Geocoding failed", message: e.message }, status: :internal_server_error
  end
end

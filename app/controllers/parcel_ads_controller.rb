class ParcelAdsController < ApplicationController
	before_action :authenticate_user!

	def index
		@parcel_ads = ParcelAd.all
	end

	def new
		@parcel_ad = ParcelAd.new
	end

	def create
		@parcel_ad = current_user.parcel_ads.build(parcel_ad_params)
		if @parcel_ad.save
			redirect_to @parcel_ad, notice: "Your add has been successfully published."
		else
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
			redirect_to @parcel_ad, notice: "Your add has been successfully updated."
		else
			render :new, alert: "Something went wrong."
		end
	end


	private	

	def parcel_ad_params
		params.require(:parcel_ad).permit(:departure_city, :arrival_city, :send_date, :parcel_type, 
      :parcel_weight, :parcel_dimension, :description, :bonus, :service_type, :photo)
	end
end

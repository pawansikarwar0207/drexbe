class TrackingController < ApplicationController
	def show
		@parcel_ad = ParcelAd.find_by!(tracking_number: params[:tracking_number]) 
	end
end

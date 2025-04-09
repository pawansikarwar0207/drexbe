class AddTrackingInfoToParcelAds < ActiveRecord::Migration[7.1]
  def change
    add_column :parcel_ads, :tracking_number, :string
    add_column :parcel_ads, :tracking_url_provider, :string
    add_column :parcel_ads, :carrier_name, :string
    add_column :parcel_ads, :service_level, :string
    add_column :parcel_ads, :estimated_days, :integer
    add_column :parcel_ads, :available_rates, :text
  end
end

class AddCustomTrackingToParcelAds < ActiveRecord::Migration[7.1]
  def change
    add_column :parcel_ads, :tracking_status, :integer
    add_column :parcel_ads, :tracking_status_updated_at, :datetime
  end
end

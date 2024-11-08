class AddLabelUrlToParcelAds < ActiveRecord::Migration[7.0]
  def change
    add_column :parcel_ads, :label_url, :string
    add_column :parcel_ads, :shipment_id, :string
    add_column :parcel_ads, :rate_id, :string    
  end
end

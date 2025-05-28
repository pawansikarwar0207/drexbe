class AddRemovalTypeToParcelAds < ActiveRecord::Migration[7.1]
  def change
    add_column :parcel_ads, :removal_type, :string
    add_column :parcel_ads, :removal_description, :text
    add_column :parcel_ads, :delievery_type, :string
    add_column :parcel_ads, :delievery_instruction, :text
    add_column :parcel_ads, :parcel_format, :string
  end
end

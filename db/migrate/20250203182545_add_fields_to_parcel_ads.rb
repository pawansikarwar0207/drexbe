class AddFieldsToParcelAds < ActiveRecord::Migration[7.1]
  def change
    add_column :parcel_ads, :time, :text
    add_column :parcel_ads, :special_instructions, :text
  end
end

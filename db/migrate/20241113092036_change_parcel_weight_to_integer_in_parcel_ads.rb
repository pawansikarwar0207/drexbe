class ChangeParcelWeightToIntegerInParcelAds < ActiveRecord::Migration[7.0]
  def change
    remove_column :parcel_ads, :parcel_weight, :string
    add_column :parcel_ads, :parcel_weight, :integer
  end
end

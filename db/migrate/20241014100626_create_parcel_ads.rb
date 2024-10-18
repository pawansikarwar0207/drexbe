class CreateParcelAds < ActiveRecord::Migration[7.0]
  def change
    create_table :parcel_ads do |t|
      t.references :user, null: false, foreign_key: true
      t.string :departure_city
      t.string :arrival_city
      t.string :departure_country
      t.string :arrival_country
      t.date :shipment_date
      t.string :parcel_type
      t.string :parcel_weight
      t.string :parcel_length
      t.string :parcel_width
      t.string :parcel_height
      t.integer :parcel_quantity
      t.boolean :insure_shipment
      t.text :description
      t.decimal :bonus
      t.string :service_type
      t.decimal :recommended_fee
      t.decimal :proposed_fee

      t.timestamps
    end
  end
end

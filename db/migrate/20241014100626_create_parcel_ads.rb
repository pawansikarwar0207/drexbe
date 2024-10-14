class CreateParcelAds < ActiveRecord::Migration[7.0]
  def change
    create_table :parcel_ads do |t|
      t.references :user, null: false, foreign_key: true
      t.string :departure_city
      t.string :arrival_city
      t.date :send_date
      t.string :parcel_type
      t.string :parcel_weight
      t.string :parcel_dimension
      t.text :description
      t.decimal :bonus
      t.string :service_type

      t.timestamps
    end
  end
end

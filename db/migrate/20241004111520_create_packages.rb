class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :sender_name
      t.string :destination_country
      t.string :destination_city
      t.date :expected_delivery_date
      t.references :traveler, null: false, foreign_key: true

      t.timestamps
    end
  end
end

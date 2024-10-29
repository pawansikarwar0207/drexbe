class CreateBuyForMes < ActiveRecord::Migration[7.0]
  def change
    create_table :buy_for_mes do |t|
      t.string :departure_country
      t.string :departure_city
      t.string :arrival_country
      t.string :arrival_city
      t.date :shopping_date
      t.string :product_link
      t.string :category
      t.string :product_name
      t.integer :product_quantity
      t.string :parcel_type
      t.decimal :product_price
      t.decimal :buy_for_me_fee
      t.decimal :total_price
      t.string :shop_name
      t.string :shop_address
      t.string :buyer_name
      t.string :buyer_contact_number
      t.string :buyer_email

      t.timestamps
    end
  end
end

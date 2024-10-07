class CreateTravelers < ActiveRecord::Migration[7.0]
  def change
    create_table :travelers do |t|
      t.string :name
      t.string :email
      t.string :country
      t.string :city
      t.string :airport
      t.date :travel_date

      t.timestamps
    end
  end
end

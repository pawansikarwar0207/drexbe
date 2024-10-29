class AddAttrToTraveler < ActiveRecord::Migration[7.0]
  def change
    remove_column :travelers, :country, :string
    remove_column :travelers, :city, :string 
    remove_column :travelers, :airport, :string
    remove_column :travelers, :from_city, :string
    remove_column :travelers, :to_city, :string

    # Adding new columns
    add_column :travelers, :trip_type, :string
    add_column :travelers, :departure_country, :string
    add_column :travelers, :departure_city, :string
    add_column :travelers, :arrival_country, :string
    add_column :travelers, :arrival_city, :string
    add_column :travelers, :transportation, :string
    add_column :travelers, :parcel_type, :string
    add_column :travelers, :parcel_qty, :integer
    add_column :travelers, :ready_to_buy_for_you, :boolean
    add_column :travelers, :parcel_collection_mode, :string
    add_column :travelers, :travel_return_date, :date

  end
end



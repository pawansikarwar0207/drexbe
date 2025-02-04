class AddTravelTimeToTravelers < ActiveRecord::Migration[7.1]
  def change
    add_column :travelers, :travel_time, :text
    add_column :travelers, :special_instructions, :text
    add_column :travelers, :parcel_weight, :integer 
    add_column :travelers, :buy_for_you, :boolean
  end
end

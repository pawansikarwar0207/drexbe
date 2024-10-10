class AddFieldsToTraveler < ActiveRecord::Migration[7.0]
  def change
    add_column :travelers, :from_city, :string
    add_column :travelers, :to_city, :string
  end
end

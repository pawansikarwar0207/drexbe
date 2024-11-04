class AddUserIdToTravelers < ActiveRecord::Migration[7.0]
  def change
    add_reference :travelers, :user, foreign_key: true
  end
end

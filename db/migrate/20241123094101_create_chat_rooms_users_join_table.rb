class CreateChatRoomsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_rooms_users, id: false do |t|
      t.references :chat_room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end

    add_index :chat_rooms_users, [:chat_room_id, :user_id], unique: true
  end
end

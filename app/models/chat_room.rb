class ChatRoom < ApplicationRecord
  has_many :messages, dependent: :destroy
  
  has_and_belongs_to_many :users
  # Find or create a chat room for two users
  def self.between(user1, user2)
    # Find existing chat room with both users
    chat_room = ChatRoom.joins(:users)
                        .where(users: { id: [user1.id, user2.id] })
                        .distinct
                        .group('chat_rooms.id')
                        .having('COUNT(users.id) = 2')
                        .first
    # If no chat room exists, create a new one
    chat_room || create(name: "#{user1.full_name} & #{user2.full_name}", users: [user1, user2])
  end

  def other_user(current_user)
    # Get the users in the chat room and find the user who is not the current_user
    users.where.not(id: current_user.id).first
  end

end

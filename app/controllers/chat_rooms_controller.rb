class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  # before_action :authorize_chat_room, only: :show

  def index
    @users = User.where.not(id: current_user.id).includes(profile_picture_blob: :attachments)

    @last_messages = {}
    
    @users.each do |user|
      chat_room = current_user.find_or_create_chat_room_with(user)
      @last_messages[user.id] = chat_room.messages.order(created_at: :desc).first
    end
  end

  def show
    @chat_room = ChatRoom.includes(users: { profile_picture_attachment: :blob }).find(params[:id])
    @messages = @chat_room.messages.includes(user: { profile_picture_attachment: :blob })
  end
  
  # def authorize_chat_room
  #   @chat_room = ChatRoom.find(params[:id])
  #   unless @chat_room.users.include?(current_user)
  #     redirect_to chat_rooms_path, alert: "You're not authorized to access this chat room."
  #   end
  # end
end

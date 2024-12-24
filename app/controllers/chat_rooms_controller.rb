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
    @chat_room = ChatRoom.includes(:users, messages: :reactions).find(params[:id])
    @other_user = @chat_room.other_user(current_user)
    @users = @chat_room.users.with_attached_profile_picture
    @messages = @chat_room.messages.includes(:user).order(created_at: :asc)

    # Group reactions by message
    @reactions_counts = Message.joins(:reactions)
                           .group('messages.id', 'reactions.emoji')
                           .count
                           .group_by { |(message_id, _), _| message_id }
                           .transform_values do |values|
                             values.to_h { |(_, emoji), count| [emoji, count] }
                           end
  end
  
  # def authorize_chat_room
  #   @chat_room = ChatRoom.find(params[:id])
  #   unless @chat_room.users.include?(current_user)
  #     redirect_to chat_rooms_path, alert: "You're not authorized to access this chat room."
  #   end
  # end
end

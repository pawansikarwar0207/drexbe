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
    @chat_room = ChatRoom.includes(:users, messages: [:reactions, :user]).find(params[:id])
    @other_user = @chat_room.other_user(current_user)
    @users = @chat_room.users.with_attached_profile_picture
    @messages = @chat_room.messages.order(:created_at)

    # Group messages by date
    @groups = grouped_messages(@messages)

    # Mark messages as 'read' for the recipient
    # Find all 'sent' messages from the other user
    unread_messages = @chat_room.messages.where(user: @other_user, status: 'sent')

    unread_messages.each do |message|
      next if message.status == 'read'  # Skip if already read

      # Mark as read and broadcast the update
      message.update(status: 'read')

      # Broadcast only the updated message with Turbo Streams
      ActionCable.server.broadcast(
        "chatroom_#{@chat_room.id}",
        turbo_stream.replace(
          "#{}message_#{message.id}", 
          partial: "messages/message", 
          locals: { message: message }
        )
      )
    end

    # Group reactions by message
    @reactions_counts = Message.joins(:reactions)
                               .group('messages.id', 'reactions.emoji')
                               .count
                               .group_by { |(message_id, _), _| message_id }
                               .transform_values do |values|
                                 values.to_h { |(_, emoji), count| [emoji, count] }
                               end
  end





  def grouped_messages(messages)
    messages.group_by do |message|
      if message.created_at.to_date == Date.current
        'Today'
      elsif message.created_at.to_date == Date.yesterday
        'Yesterday'
      else
        message.created_at.strftime('%B %d, %Y') # Example: "August 23, 2024"
      end
    end
  end

  
  # def authorize_chat_room
  #   @chat_room = ChatRoom.find(params[:id])
  #   unless @chat_room.users.include?(current_user)
  #     redirect_to chat_rooms_path, alert: "You're not authorized to access this chat room."
  #   end
  # end
end

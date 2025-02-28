class MessagesController < ApplicationController
  include ActionView::RecordIdentifier # To use dom_id in the controller
  before_action :set_message, only: [:mark_as_delivered, :mark_as_read]
  
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      @message.update(status: 'sent') # Default to 'sent'

      # Identify the recipient (assuming a chat room has exactly two participants)
      recipient = @chat_room.users.where.not(id: current_user.id).first

      # Create a notification for the recipient
      if recipient
        Notification.create(
          user: recipient,
          chat_room: @chat_room.id,
          message: "#{current_user.full_name} sent you a message",
          read: false
        )

        # Broadcast notification update to recipient
        Turbo::StreamsChannel.broadcast_replace_to(
          "notifications_#{recipient.id}",
          target: "notification_bell",
          partial: "shared/bell",
          locals: { user: recipient }
        )
      end

      # Broadcast new message to chat room
      Turbo::StreamsChannel.broadcast_append_to(
        "chatroom_#{@chat_room.id}",
        target: "message_frame",
        partial: "messages/message",
        locals: { message: @message, chat_room: @chat_room }
      )
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def react
    @chat_room = ChatRoom.find(params[:chat_room_id])  # Fetch the chat room
    @message = @chat_room.messages.find(params[:id])   # Find the message in the chat room
    emoji = params[:emoji]                             # Emoji sent by the user

    # Find or create a reaction for the current user and message
    reaction = Reaction.find_or_initialize_by(user: current_user, message: @message)
    if reaction.persisted? && reaction.emoji == emoji
      reaction.destroy
    else
      # Otherwise, update or create the reaction with the new emoji
      reaction.emoji = emoji
      reaction.save!
    end

    # Group reactions by emoji for the message
    @reactions_counts = @message.reactions.group_by(&:emoji).transform_values(&:count)

    # Broadcast updated reactions to all subscribers
    ActionCable.server.broadcast(
      "chatroom_#{@chat_room.id}",
      turbo_stream.replace(
        dom_id(@message, :reactions),  # Use the dom_id to target the reactions div
        partial: "messages/reactions",
        locals: { message: @message, reactions_counts: @reactions_counts }
      )
    )

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

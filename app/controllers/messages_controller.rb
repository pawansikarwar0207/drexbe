class MessagesController < ApplicationController
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      session[:last_sender_id] = current_user.id
      # Broadcast the message to all subscribers of the chat room
      ActionCable.server.broadcast("chatroom_#{@chat_room.id}", turbo_stream.append('message_frame', partial: "messages/message", locals: { message: @message }))
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

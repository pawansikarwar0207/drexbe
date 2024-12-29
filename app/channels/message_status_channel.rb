class MessageStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_status_#{params[:chat_room_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

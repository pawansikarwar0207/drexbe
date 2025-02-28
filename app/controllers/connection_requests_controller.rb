class ConnectionRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @receiver = User.find(params[:receiver_id])
    @request = ConnectionRequest.create(sender: current_user, receiver: @receiver, status: "pending")
    chat_room = @request.sender.find_or_create_chat_room_with(@request.receiver)
    ConnectionRequestMailer.request_notification(@request).deliver_later
    @notification = Notification.create(user: @receiver, chat_room: chat_room.id, message: "#{current_user.full_name} sent you a connection request.")
    # Send Turbo Stream update
    Turbo::StreamsChannel.broadcast_replace_to(
      "notifications_#{@receiver.id}",
      target: "notification_bell",
      partial: "shared/bell",
      locals: { user: @receiver }
    )
  end

  def accept
    begin
      @request = ConnectionRequest.find(params[:id])
      
      if @request.update(status: "accepted")
        @request.sender.find_or_create_chat_room_with(@request.receiver)
        redirect_to chat_rooms_path, notice: "You are now connected with #{@request.sender.full_name}."
      else
        redirect_to chat_rooms_path, alert: "Failed to accept the request. Please try again."
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to chat_rooms_path, alert: "Connection request not found."
    rescue StandardError => e
      logger.error "Error accepting connection request: #{e.message}"
      redirect_to chat_rooms_path, alert: "Something went wrong. Please try again later."
    end
  end

  def reject
    @request = ConnectionRequest.find(params[:id])
    @request.destroy
    redirect_to root_path, alert: "Connection request rejected."
  end
end

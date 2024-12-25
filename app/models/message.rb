class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user

  has_many :reactions, dependent: :destroy

  enum status: { sent: 'sent', delivered: 'delivered' }

  # Set the default status to 'sent' when a message is created
  after_create :set_sent_status

  private

  def set_sent_status
    update(status: :sent)
  end
end

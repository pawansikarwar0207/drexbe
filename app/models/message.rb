class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user
  has_many :reactions, dependent: :destroy

  STATUSES = %w[sent delivered read].freeze
end

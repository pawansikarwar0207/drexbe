class Announcement < ApplicationRecord
  belongs_to :user, dependent: :destroy
end

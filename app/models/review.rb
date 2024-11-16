class Review < ApplicationRecord
	belongs_to :reviewer, class_name: 'User'
	belongs_to :reviewee, class_name: 'User'

	validates :rating, presence: true, inclusion: { in: 1..5 }
	validates :reviewer_id, uniqueness: { scope: :reviewee_id, message: "You have already reviewed this user" }
	validates :comment, presence: true
  validates :reviewer_id, presence: true
  validates :reviewee_id, presence: true
  validate :reviewer_cannot_be_reviewee

  private

  def reviewer_cannot_be_reviewee
  	if reviewer_id == reviewee_id
  		errors.add(:reviewer_id, "You cannot review yourself.")
  	end
  end
end

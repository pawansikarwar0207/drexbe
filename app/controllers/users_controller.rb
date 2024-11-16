class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @review = @user.received_reviews.find_by(reviewer_id: current_user.id)
  end
end

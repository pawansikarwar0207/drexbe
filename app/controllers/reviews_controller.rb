class ReviewsController < ApplicationController
	before_action :set_user, only: [:index, :new, :create, :destroy]

	def index
		@reviews = @user.received_reviews.includes(:reviewer, :reviewee)	
		@label_counts = Review.where(reviewee_id: @user.id).group(:comment).count #for showing the comment counts according to the label
		@review = @user.received_reviews.new
	end

	def new
		@review = @user.received_reviews.new
	end

	def create
		@review = @user.received_reviews.new(review_params)

		@review.reviewer = current_user

		if @review.save
			redirect_to user_reviews_path(@user), notice: 'Review was successfully created.'
		else
			@reviews = @user.received_reviews.includes(:reviewer)
			render :index, status: :unprocessable_entity
		end
	end

	def destroy
		@review = @user.received_reviews.find(params[:id])
    @review.destroy
    redirect_to user_reviews_path(@user), alert: 'Review was successfully deleted.'
  end

	private

	def set_user
		@user = User.find(params[:user_id])
	end

	def review_params
		params.require(:review).permit(:rating, :comment, :custom_comment)
	end
end

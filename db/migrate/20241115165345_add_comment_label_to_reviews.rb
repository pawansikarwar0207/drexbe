class AddCommentLabelToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :comment_label, :string
    add_column :reviews, :custom_comment, :text
  end
end

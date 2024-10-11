class AddAttrToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users,:confirmation_token, :string
    add_column :users,:confirmed_at, :datetime
    add_column :users,:confirmation_sent_at, :datetime
    add_column :users,:unconfirmed_email, :string
    add_column :users,:address_1, :string
    add_column :users,:address_2, :string
  end
end

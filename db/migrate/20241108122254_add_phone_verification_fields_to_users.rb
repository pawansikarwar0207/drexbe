class AddPhoneVerificationFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :verification_code, :string
  end
end

class AddUserTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_type, :string, null: false, default: "individual"
  end
end

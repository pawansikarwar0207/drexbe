class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :postal_code, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :profile_picture, :string
  end
end

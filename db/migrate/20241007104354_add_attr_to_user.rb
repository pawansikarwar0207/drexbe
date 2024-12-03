class AddAttrToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users,:address_1, :string
    add_column :users,:address_2, :string
  end
end

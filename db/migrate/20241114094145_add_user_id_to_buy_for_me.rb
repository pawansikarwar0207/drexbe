class AddUserIdToBuyForMe < ActiveRecord::Migration[7.0]
  def change
    add_reference :buy_for_mes, :user, foreign_key: true
  end
end

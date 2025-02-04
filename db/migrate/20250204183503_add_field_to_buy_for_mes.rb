class AddFieldToBuyForMes < ActiveRecord::Migration[7.1]
  def change
    add_column :buy_for_mes, :special_instructions, :text
    add_column :buy_for_mes, :delivery_time, :text
  end
end

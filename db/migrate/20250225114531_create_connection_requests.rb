class CreateConnectionRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :connection_requests do |t|
      t.references :sender, foreign_key: { to_table: :users }, null: false
      t.references :receiver, foreign_key: { to_table: :users }, null: false
      t.string :status, default: 'pending' # Status: 'pending', 'accepted', 'rejected'

      t.timestamps
    end
  end
end

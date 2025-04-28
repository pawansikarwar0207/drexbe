class CreateSentNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :sent_notifications do |t|
      t.references :parcel_ad, null: false, foreign_key: true
      t.string :subject
      t.string :body
      t.string :recipient
      t.datetime :sent_at

      t.timestamps
    end
  end
end

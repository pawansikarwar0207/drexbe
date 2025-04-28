class CreateTrackingEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :tracking_events do |t|
      t.references :parcel_ad, null: false, foreign_key: true
      t.integer :status
      t.text :description
      t.datetime :occurred_at

      t.timestamps
    end
  end
end

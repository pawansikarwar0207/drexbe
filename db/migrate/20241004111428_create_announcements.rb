class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.string :announcement_type
      t.string :country
      t.string :city
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

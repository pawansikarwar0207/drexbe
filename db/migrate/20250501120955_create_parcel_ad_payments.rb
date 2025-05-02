class CreateParcelAdPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :parcel_ad_payments do |t|
      t.references :parcel_ad, null: false, foreign_key: true
      t.string :stripe_payment_intent_id
      t.integer :amount_cents
      t.string :status

      t.timestamps
    end
  end
end

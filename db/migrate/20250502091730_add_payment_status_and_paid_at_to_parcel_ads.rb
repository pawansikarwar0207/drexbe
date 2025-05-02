class AddPaymentStatusAndPaidAtToParcelAds < ActiveRecord::Migration[7.1]
  def change
    add_column :parcel_ads, :payment_status, :string
    add_column :parcel_ads, :paid_at, :datetime
    add_column :parcel_ads, :payment_intent_id, :string
  end
end

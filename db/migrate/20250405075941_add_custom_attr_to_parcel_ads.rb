class AddCustomAttrToParcelAds < ActiveRecord::Migration[7.1]
  def change
    # parcel sender
    add_column :parcel_ads, :address_from_street1, :string
    add_column :parcel_ads, :address_from_street2, :string
    add_column :parcel_ads, :address_from_street3, :string
    add_column :parcel_ads, :address_from_state, :string
    add_column :parcel_ads, :address_from_zip, :string
    add_column :parcel_ads, :address_from_street_no, :string
    add_column :parcel_ads, :address_from_is_residential, :boolean
    add_column :parcel_ads, :parcel_sender_name, :string
    add_column :parcel_ads, :parcel_sender_phone, :string
    add_column :parcel_ads, :parcel_sender_email, :string

    # parcel receiver
    add_column :parcel_ads, :address_to_street1, :string
    add_column :parcel_ads, :address_to_street2, :string
    add_column :parcel_ads, :address_to_street3, :string
    add_column :parcel_ads, :address_to_state, :string
    add_column :parcel_ads, :address_to_zip, :string
    add_column :parcel_ads, :address_to_street_no, :string
    add_column :parcel_ads, :address_to_is_residential, :boolean
    add_column :parcel_ads, :parcel_receiver_name, :string
    add_column :parcel_ads, :parcel_receiver_phone, :string
    add_column :parcel_ads, :parcel_receiver_email, :string
  end
end

class BuyForMe < ApplicationRecord
	# validates :departure_country, presence: true
  validates :departure_city, presence: true
  # validates :arrival_country, presence: true
  validates :arrival_city, presence: true
  validates :shopping_date, presence: true
  validates :product_link, presence: true
  validates :shop_name, :shop_address, presence: true
  validates :category, presence: true
  validates :product_name, presence: true
  validates :product_quantity, numericality: { greater_than: 0 }
  validates :parcel_type, inclusion: { in: %w[small medium large] }
  validates :product_price, numericality: { greater_than_or_equal_to: 0 }
  validates :buy_for_me_fee, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  def calculate_product_cost
    total_cost = product_price.to_f + buy_for_me_fee.to_f
  end

  def self.ransackable_attributes(auth_object = nil)
    ["arrival_city", "arrival_country", "buy_for_me_fee", "buyer_contact_number", "buyer_email", "buyer_name", "category", "created_at", "departure_city", "departure_country", "id", "parcel_type", "product_link", "product_name", "product_price", "product_quantity", "shop_address", "shop_name", "shopping_date", "total_price", "updated_at"]
  end

end

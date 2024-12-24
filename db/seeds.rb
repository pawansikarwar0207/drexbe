# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create dummy travelers
Traveler.create!([
  {
    name: "John Doe",
    email: "john.doe@example.com",
    travel_date: Date.today + 7.days,
    trip_type: "round_trip",
    departure_country: "USA",
    departure_city: "New York",
    arrival_country: "France",
    arrival_city: "Paris",
    transportation: "bus",
    parcel_type: "Documents",
    parcel_qty: 2,
    ready_to_buy_for_you: true,
    parcel_collection_mode: "Pickup",
    travel_return_date: Date.today + 14.days,
    user_id: 1
  },
  {
    name: "Jane Smith",
    email: "jane.smith@example.com",
    travel_date: Date.today + 10.days,
    trip_type: "one_way",
    departure_country: "Canada",
    departure_city: "Toronto",
    arrival_country: "UK",
    arrival_city: "London",
    transportation: "train",
    parcel_type: "Electronics",
    parcel_qty: 1,
    ready_to_buy_for_you: false,
    parcel_collection_mode: "Delivery",
    travel_return_date: Date.today + 10.days,
    user_id: 2
  },
  {
    name: "Alice Johnson",
    email: "alice.johnson@example.com",
    travel_date: Date.today + 20.days,
    trip_type: "round_trip",
    departure_country: "Australia",
    departure_city: "Sydney",
    arrival_country: "Japan",
    arrival_city: "Tokyo",
    transportation: "ship",
    parcel_type: "Clothing",
    parcel_qty: 3,
    ready_to_buy_for_you: true,
    parcel_collection_mode: "Pickup",
    travel_return_date: Date.today + 30.days,
    user_id: 3
  }
])

puts "Traveler data successfully created!"

5.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "123456", # Devise will handle the encryption
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    city: Faker::Address.city,
    country: Faker::Address.country,
    postal_code: Faker::Number.number(digits: 5), # Generates a numeric postal code
    address_1: Faker::Address.street_address,
    address_2: Faker::Address.secondary_address,
    user_type: %w[individual professional].sample
  )
end

puts "5 dummy users created successfully!"
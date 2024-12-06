# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create dummy travelers
traveler1 = Traveler.create!(
  name: "John Doe",
  email: "john@example.com",
  country: "USA",
  city: "New York",
  airport: "JFK",
  travel_date: Date.today + 10.days
)

traveler2 = Traveler.create!(
  name: "Jane Smith",
  email: "jane@example.com",
  country: "France",
  city: "Paris",
  airport: "CDG",
  travel_date: Date.today + 15.days
)

traveler3 = Traveler.create!(
  name: "Emily Johnson",
  email: "emily@example.com",
  country: "Germany",
  city: "Berlin",
  airport: "BER",
  travel_date: Date.today + 7.days
)

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
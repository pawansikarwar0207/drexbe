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

# Create dummy announcements
Announcement.create!(
  announcement_type: "send_package",
  country: "USA",
  city: "New York",
  date: Date.today + 5.days,
  user_id: 1 # Assuming a user with ID 1 exists
)

Announcement.create!(
  announcement_type: "buy_item",
  country: "France",
  city: "Paris",
  date: Date.today + 3.days,
  user_id: 1
)

Announcement.create!(
  announcement_type: "send_package",
  country: "Germany",
  city: "Berlin",
  date: Date.today + 2.days,
  user_id: 1
)

puts "Dummy data successfully created!"
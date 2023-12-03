# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a main sample player.
Player.create!(name: "Example Player",
             email: "player@example.com",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true)

# Generate a bunch of additional players.
40.times do |n|
  name = Faker::Name.name
  email = "player-#{n+1}@example.com"
  password = "password"
  Player.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

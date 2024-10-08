# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Poster.create(
  name: "REGRET",
  description: "Hard work rarely pays off.",
  price: 89.00,
  year: 2018,
  vintage: true,
  img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

Poster.create(
  name: "UNHAPPY",
  description: "Hard work rarely pays off.",
  price: 400.00,
  year: 1738,
  vintage: true,
  img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

Poster.create(
  name: "BIG SAD",
  description: "Why smile when you can frown",
  price: 120.00,
  year: 2020,
  vintage: false,
  img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

Poster.create(
  name: "SHAME",
  description: "Hard work rarely pays off.",
  price: 11.00,
  year: 2000,
  vintage: true,
  img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

Poster.create(
  name: "TERRIBLE",
  description: "It's too awful to look at.",
  price: 15.00,
  year: 1738,
  vintage: true,
  img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

Poster.create(
  name: "DISASTER",
  description: "It's a mess and you haven't even started yet.",
  price: 28.00,
  year: 2016,
  vintage: false,
  img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

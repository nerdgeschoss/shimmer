# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Post.find_each do |post|
  post.image.attach(
    io: File.open("#{Rails.root}/spec/fixtures/files/nerdgeschoss.jpg"),
    filename: "nerdgeschoss.jpg",
    content_type: "image/jpeg"
  )
end

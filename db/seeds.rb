# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke

BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 5.0, merchant: merchant1)
BulkDiscount.create!(quantity_threshold: 20, percentage_discount: 10.0, merchant: merchant1)
BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 7.5, merchant: merchant2)
BulkDiscount.create!(quantity_threshold: 25, percentage_discount: 12.5, merchant: merchant2)
BulkDiscount.create!(quantity_threshold: 30, percentage_discount: 15.0, merchant: merchant3)
BulkDiscount.create!(quantity_threshold: 50, percentage_discount: 20.0, merchant: merchant3)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Book.create title: 'O nome do Vento', author: "Patrick Rothfuss"
Book.create title: 'Harry Potter', author: "JK Rooling"
Book.create title: 'O Hobbit', author: "JRR Tolkien"
Book.create title: 'O peregrino', author: "John Bunyan"
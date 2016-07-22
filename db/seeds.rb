# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'Music')
Subject.create(name: 'Guitar', category_id: 1)
Subject.create(name: 'Drums', category_id: 1)
Subject.create(name: 'Piano', category_id: 1)

Teacher.create( first_name: "Bob", last_name: "Builder", password: "Football1", email: "lllouis1@yahoo.com")
Teacher.create( first_name: "Tim", last_name: "Shanks", password: "Football1", email: "lllouis2@yahoo.com")
Teacher.create( first_name: "Karl", last_name: "Beans", password: "Football1", email: "lllouis3@yahoo.com")

Teacher.all.each do |t|
  t.subjects << Subject.first
end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Category.create(name: 'Music')
# Subject.create(name: 'Guitar', category_id: 1)
# Subject.create(name: 'Drums', category_id: 1)
# Subject.create(name: 'Piano', category_id: 1)

# t1 = Teacher.create( first_name: "Bob", last_name: "Builder", password: "Football1", email: "lllouis1@yahoo.com", is_teacher: true)
# t2 = Teacher.create( first_name: "Tim", last_name: "Shanks", password: "Football1", email: "lllouis2@yahoo.com", is_teacher: true)
# t3 = Teacher.create( first_name: "Karl", last_name: "Beans", password: "Football1", email: "lllouis3@yahoo.com", is_teacher: true)

# Location.create( latitude: 53.268382, longitude: -9.056652, name: "Galway", address: "Galway", teacher_id: t1.id )
# Location.create( latitude: 52.665655, longitude: -8.635292, name: "Limerick", address: "Limerick", teacher_id: t2.id )
# Location.create( latitude: 53.344739, longitude: -6.267685, name: "Dublin", address: "Dublin", teacher_id: t3.id )

# Teacher.all.each do |t|
#   t.subjects << Subject.first
# end

# conversation = Conversation.create( teacher_email: "lllouis@yahoo.com", student_email: "louisangelini@gmail.com", teacher_name: "Louis", student_name: "Aidan" )
# conversationb = Conversation.create( teacher_email: "lllouis@yahoo.com", student_email: "louisangelini2@gmail.com", teacher_name: "Louis", student_name: "Paul" )

# (0..5).each do |i|
#   Message.create( message: "hello there", conversation_id: conversation.id, sender_email: "louisangelini@gmail.com" )
#   Message.create( message: "I am ze teacher", conversation_id: conversation.id, sender_email: "lllouis@yahoo.com" )
#   Message.create( message: "Alright boi", conversation_id: conversationb.id, sender_email: "louisangelini2@gmail.com")
#   Message.create( message: "hahahaha", conversation_id: conversationb.id, sender_email: "lllouis@yahoo.com")
# end


# for i in 0..5
#   Teacher.create( first_name: "student#{ i }", last_name: "McStudent", password: "Football1", email: "louisangelini#{ i }@gmail.com", is_teacher: false )
# end

conversation = Conversation.create( teacher_email: 'lllouis@yahoo.com', student_email: 'louisangelini1@gmail.com', teacher_name: 'Louis', student_name: 'Jimbo')

(0..5).each do |i|
  Message.create( message: "hello there", conversation_id: conversation.id, sender_email: "louisangelini1@gmail.com" )
  Message.create( message: "I am ze teacher", conversation_id: conversation.id, sender_email: "lllouis@yahoo.com" )
  Message.create( message: "Alright boi", conversation_id: conversation.id, sender_email: "louisangelini1@gmail.com")
  Message.create( message: "hahahaha", conversation_id: conversation.id, sender_email: "lllouis@yahoo.com")
end

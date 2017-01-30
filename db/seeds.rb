# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)

# Category.create(name: 'Music')
# Subject.create(name: 'Guitar', category_id: 1)
# Subject.create(name: 'Drums', category_id: 1)
# Subject.create(name: 'Piano', category_id: 1)
# Subject.create(name: "Acoustic Guitar", category_id: 1 )

# t1 = Teacher.create( first_name: "Bob", last_name: "Builder", password: "Football1", email: "lllouis1@yahoo.com", is_teacher: true)
# t2 = Teacher.create( first_name: "Tim", last_name: "Shanks", password: "Football1", email: "lllouis2@yahoo.com", is_teacher: true)
# t3 = Teacher.create( first_name: "Karl", last_name: "Beans", password: "Football1", email: "lllouis3@yahoo.com", is_teacher: true)

# Location.create(  address: "Galway", county: 'Co. Galway', teacher_id: t1.id )
# Location.create(  address: "Limerick", county: 'Co. Limerick', teacher_id: t2.id )
# Location.create(  address: "Dublin", county: 'Co. Dublin', teacher_id: t3.id )

# Teacher.all.each do |t|
#   t.subjects << Subject.first
# end

# Teacher.last.subjects << Subject.last
# Teacher.first.subjects << Subject.last

# # conversation = Conversation.create( user_email1: "lllouis@yahoo.com", user_email2: "louisangelini@gmail.com", user_name1: "Louis", user_name2: "Aidan" )
# # conversationb = Conversation.create( user_email1: "lllouis@yahoo.com", user_email2: "louisangelini2@gmail.com", user_name1: "Louis", user_name2: "Paul" )

# # (0..5).each do |i|
# #   Message.create( text: "hello there", conversation_id: conversation.id )
# #   Message.create( text: "I am ze teacher", conversation_id: conversation.id )
# #   Message.create( text: "Alright boi", conversation_id: conversationb.id )
# #   Message.create( text: "hahahaha", conversation_id: conversationb.id )
# # end


# for i in 0..5
#   Teacher.create( first_name: "student#{ i }", last_name: "McStudent", password: "Football1", email: "louisangelini#{ i }@gmail.com", is_teacher: false )
# end

# conversation = Conversation.create( user_id1: Teacher.first.id, user_id2: Teacher.last.id, user_email1: Teacher.first.email, user_email2: Teacher.last.email, user_name1: Teacher.first.first_name, user_name2: Teacher.last.first_name )

# (0..5).each do |i|
#   Message.create( text: "hello there", conversation_id: conversation.id )
#   Message.create( text: "I am ze teacher", conversation_id: conversation.id )
#   Message.create( text: "Alright boi", conversation_id: conversation.id )
#   Message.create( text: "hahahaha", conversation_id: conversation.id )
# end

Teacher.find_by(email: "lllouis@yahoo.com1").destroy
Teacher.find_by(email: "lllouis@yahoo.com2").destroy
Teacher.find_by(email: "lllouis@yahoo.com3").destroy
Teacher.find_by(email: "lllouis@yahoo.com4").destroy
Teacher.find_by(email: "lllouis@yahoo.com5").destroy
Teacher.find_by(email: "lllouis@yahoo.com6").destroy
Teacher.find_by(email: "lllouis@yahoo.com7").destroy
Teacher.find_by(email: "lllouis@yahoo.com8").destroy
Teacher.find_by(email: "lllouis@yahoo.com9").destroy
Teacher.find_by(email: "lllouis@yahoo.com10").destroy
Teacher.find_by(email: "lllouis@yahoo.com11").destroy
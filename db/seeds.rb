# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_users = User.where(role: "admin")
if(admin_users.count==0)
	admin = User.new(first_name: "Tanmay", last_name: "Patil", role: "admin")
	e = EmailAddress.new(email: "tanmay.ashok.patil@gmail.com")
	admin.email_addresses << e
	admin.save
end

ApiConfiguration.create(client_id: "3aa48b03449f48bf5b3b", client_secret: "bbc8f069b405a3f2291fc3f8394df41306135b59")

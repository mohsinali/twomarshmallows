# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.delete_all
ActiveRecord::Base.connection.execute("ALTER SEQUENCE roles_id_seq RESTART WITH 1")

['superadmin', 'teacher', 'student'].each do |role_name|
  Role.create! name: role_name
end
puts "Roles created successfully."


admin = User.create(name: "Mohsin Ali", email: "admin@twomarshmallows.com", password: '321321321', is_active: true)
admin.add_role :superadmin



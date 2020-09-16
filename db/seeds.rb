# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

super_company = Company.create(name: "Super Company")
admin_company = Company.create(name: "Company Name")

super_user = User.create(email: "superuser@tranact.com", first_name: "Super", last_name: "User", company_id: super_company.id, 
  role: 'super', active: true, confirmed_at: Time.now, password: "Kolakola1", password_confirmation: "Kolakola1")

admin_user = User.create(email: "admin@company.com", first_name: "Admin", last_name: "User", company_id: admin_company.id, 
  role: 'admin', active: true, confirmed_at: Time.now, password: "kolakola", password_confirmation: "kolakola")

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Admin allowlist - these emails are authorized for admin access
admin_emails = [
  'admin@launchpadlab.com',
  'assessment@launchpadlab.com'
]

puts "Setting up admin allowlist..."

admin_emails.each do |email|
  admin = Admin.find_or_create_by(email: email)
  if admin.persisted?
    puts "✓ Admin created/found: #{email}"
  else
    puts "✗ Failed to create admin: #{email} - #{admin.errors.full_messages.join(', ')}"
  end
end

puts "Admin setup complete!"

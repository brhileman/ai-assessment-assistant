# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/magic_link
  def magic_link
    admin = Admin.first || Admin.new(email: 'admin@launchpadlab.com')
    token = 'preview_token_123'
    AdminMailer.magic_link(admin, token)
  end

end

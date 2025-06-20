# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer_mailer/magic_link
  def magic_link
    AdminMailer.magic_link
  end

end

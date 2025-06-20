class AdminMailer < ApplicationMailer
  default from: 'brett@launchpadlab.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.magic_link.subject
  #
  def magic_link(admin, token, opts = {})
    @admin = admin
    @token = token
    @remember_me = opts[:remember_me]
    @magic_link_url = admin_magic_link_auth_url(
      admin_magic_link_token: @token,
      remember_me: @remember_me,
      host: host,
      port: port
    )
    
    mail(
      to: @admin.email,
      subject: 'AI Assessment Assistant - Admin Login Link'
    )
  end
  
  private
  
  def host
    Rails.env.production? ? 'your-production-domain.com' : 'localhost'
  end
  
  def port
    Rails.env.production? ? nil : 3000
  end
end

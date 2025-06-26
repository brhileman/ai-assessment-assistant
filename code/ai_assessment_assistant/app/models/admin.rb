class Admin < ApplicationRecord
  # Configure for passwordless magic link authentication
  devise :magic_link_authenticatable, :trackable

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Admin allowlist validation - check against credentials or default list
  validate :email_in_allowlist
  
  # Magic link configuration
  def send_magic_link(request_object = nil, opts = {})
    # Generate and send magic link email
    raw, enc = Devise.token_generator.generate(self.class, :magic_link_token)
    self.magic_link_token = enc
    self.magic_link_sent_at = Time.current
    save(validate: false)
    
    # Send the magic link email
    AdminMailer.magic_link(self, raw, opts).deliver_now
    raw
  end
  
  def magic_link_expired?
    magic_link_sent_at && magic_link_sent_at < 1.hour.ago
  end
  
  private
  
  def email_in_allowlist
    allowlist = Rails.application.credentials.admin_allowlist || ['admin@launchpadlab.com', 'assessment@launchpadlab.com', 'brett@launchpadlab.com']
    unless allowlist.include?(email)
      errors.add(:email, "is not authorized for admin access")
    end
  end
end

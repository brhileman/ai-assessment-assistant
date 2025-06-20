class Admin < ApplicationRecord
  # Configure for passwordless authentication - start with basic Devise setup
  devise :database_authenticatable, :trackable

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Admin allowlist validation - temporarily relaxed for development setup
  validate :email_in_allowlist, unless: -> { Rails.env.development? && ENV['SKIP_ALLOWLIST'] }
  
  private
  
  def email_in_allowlist
    allowlist = Rails.application.credentials.admin_allowlist || ['admin@launchpadlab.com', 'assessment@launchpadlab.com']
    unless allowlist.include?(email)
      errors.add(:email, "is not authorized for admin access")
    end
  end
end

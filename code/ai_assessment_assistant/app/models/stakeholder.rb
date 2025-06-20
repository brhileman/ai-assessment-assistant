class Stakeholder < ApplicationRecord
  # Relationships
  belongs_to :company
  has_one :assessment, dependent: :destroy
  
  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :company_id, message: "already exists for this company" }
  validates :invitation_token, presence: true, uniqueness: true
  
  # Callbacks
  before_validation :generate_invitation_token, on: :create
  
  # Enums for status tracking
  enum :status, { 
    invited: 0, 
    assessment_started: 1, 
    assessment_completed: 2 
  }
  
  # Scope methods for common queries
  scope :with_assessments, -> { joins(:assessment) }
  scope :without_assessments, -> { left_joins(:assessment).where(assessments: { id: nil }) }
  scope :completed_assessments, -> { joins(:assessment).where.not(assessments: { completed_at: nil }) }
  scope :pending_assessments, -> { where(status: [:invited, :assessment_started]) }
  
  # Override to_param for URL generation using UUID token
  def to_param
    invitation_token
  end
  
  # Business Logic Methods
  def assessment_completed?
    assessment&.completed_at.present?
  end
  
  def assessment_in_progress?
    assessment.present? && !assessment_completed?
  end
  
  def can_start_assessment?
    invited? && assessment.nil?
  end
  
  def update_status_based_on_assessment!
    if assessment_completed?
      update!(status: :assessment_completed)
    elsif assessment.present?
      update!(status: :assessment_started)
    else
      update!(status: :invited)
    end
  end
  
  # Token validation methods
  def self.find_by_token(token)
    find_by(invitation_token: token)
  end
  
  def self.find_by_token!(token)
    find_by!(invitation_token: token)
  end
  
  def regenerate_invitation_token!
    update!(invitation_token: SecureRandom.uuid)
  end
  
  # Helper methods for UI display
  def display_name
    name.present? ? name : "Unnamed Stakeholder"
  end
  
  def display_status
    status.humanize
  end
  
  def assessment_completion_date
    assessment&.completed_at&.strftime("%B %d, %Y")
  end
  
  private
  
  def generate_invitation_token
    self.invitation_token = SecureRandom.uuid if invitation_token.blank?
  end
end

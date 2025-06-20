class Company < ApplicationRecord
  # Relationships
  has_many :stakeholders, dependent: :destroy
  has_many :assessments, through: :stakeholders
  
  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :custom_instructions, length: { maximum: 1000 }
  
  # Business Logic Methods
  def assessment_completion_rate
    return 0 if stakeholders.empty?
    completed = stakeholders.joins(:assessment).count
    (completed.to_f / stakeholders.count * 100).round(1)
  end
  
  # Alias for shorter method name used in views/controllers
  def completion_rate
    assessment_completion_rate
  end
  
  def pending_assessments_count
    stakeholders.left_joins(:assessment).where(assessments: { id: nil }).count
  end
  
  def completed_assessments_count
    stakeholders.joins(:assessment).where.not(assessments: { completed_at: nil }).count
  end
  
  def total_stakeholders_count
    stakeholders.count
  end
  
  # Scope methods for common queries
  scope :with_stakeholders, -> { joins(:stakeholders).distinct }
  scope :with_completed_assessments, -> { joins(stakeholders: :assessment).where.not(assessments: { completed_at: nil }).distinct }
  
  # Helper methods for UI display
  def display_name
    name.present? ? name : "Unnamed Company"
  end
  
  def has_custom_instructions?
    custom_instructions.present?
  end
end

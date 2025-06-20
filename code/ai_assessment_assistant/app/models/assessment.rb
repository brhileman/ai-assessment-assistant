class Assessment < ApplicationRecord
  belongs_to :stakeholder
  
  validates :stakeholder, uniqueness: { message: "can only have one assessment" }
  validates :full_transcript, presence: true, on: :update
  
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_completion_date, -> { order(:completed_at) }
  
  def completed?
    completed_at.present?
  end
  
  def in_progress?
    !completed?
  end
  
  def duration_minutes
    return nil unless completed_at && created_at
    ((completed_at - created_at) / 1.minute).round
  end
  
  def duration_seconds
    return nil unless completed_at && created_at
    (completed_at - created_at).round
  end
  
  def transcript_word_count
    return 0 if full_transcript.blank?
    full_transcript.split.length
  end
  
  def transcript_character_count
    return 0 if full_transcript.blank?
    full_transcript.length
  end
  
  def mark_completed!
    update!(completed_at: Time.current)
    stakeholder.update_status_based_on_assessment!
  end
  
  def has_transcript?
    full_transcript.present?
  end
  
  def display_status
    completed? ? "Completed" : "In Progress"
  end
  
  def completion_date_formatted
    completed_at&.strftime("%B %d, %Y at %I:%M %p")
  end
  
  def duration_formatted
    return "Not completed" unless completed?
    
    minutes = duration_minutes
    return "Less than 1 minute" if minutes < 1
    
    if minutes < 60
      "#{minutes} minute#{'s' if minutes != 1}"
    else
      hours = minutes / 60
      remaining_minutes = minutes % 60
      result = "#{hours} hour#{'s' if hours != 1}"
      result += " #{remaining_minutes} minute#{'s' if remaining_minutes != 1}" if remaining_minutes > 0
      result
    end
  end
  
  def transcript_summary
    return "No transcript" if full_transcript.blank?
    
    word_count = transcript_word_count
    "#{word_count} word#{'s' if word_count != 1}"
  end
  
  def self.average_duration_minutes
    completed_assessments = completed.where.not(created_at: nil)
    return 0 if completed_assessments.empty?
    
    total_duration = completed_assessments.sum do |assessment|
      assessment.duration_minutes || 0
    end
    
    (total_duration.to_f / completed_assessments.count).round(1)
  end
  
  def self.completion_rate
    return 0 if count == 0
    (completed.count.to_f / count * 100).round(1)
  end
end

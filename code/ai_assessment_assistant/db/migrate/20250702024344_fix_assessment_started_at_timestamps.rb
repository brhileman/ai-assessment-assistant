class FixAssessmentStartedAtTimestamps < ActiveRecord::Migration[8.0]
  def up
    # For assessments that don't have started_at set
    Assessment.where(started_at: nil).find_each do |assessment|
      if assessment.completed_at.present?
        # For completed assessments, estimate started_at based on reasonable duration
        # Most voice assessments should be 10-30 minutes
        # If duration is unreasonable (>2 hours), cap it at 30 minutes
        estimated_duration = assessment.completed_at - assessment.created_at
        
        if estimated_duration > 2.hours
          # Likely created long before actual start, assume 20 minute assessment
          assessment.update_column(:started_at, assessment.completed_at - 20.minutes)
        else
          # Use created_at as started_at
          assessment.update_column(:started_at, assessment.created_at)
        end
      else
        # For in-progress assessments, use created_at as best guess
        assessment.update_column(:started_at, assessment.created_at)
      end
    end
  end
  
  def down
    # This migration is not easily reversible
    # We could set all started_at to nil, but that would lose data
    raise ActiveRecord::IrreversibleMigration
  end
end

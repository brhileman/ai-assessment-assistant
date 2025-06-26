class CleanupAssessmentStartedStatus < ActiveRecord::Migration[8.0]
  def up
    # Update any stakeholders with 'assessment_started' status (1) to 'invited' status (0)
    execute <<-SQL
      UPDATE stakeholders 
      SET status = 0 
      WHERE status = 1
    SQL
  end

  def down
    # No reversal needed as we're removing the assessment_started status
    # If needed in the future, these records would need manual review
  end
end

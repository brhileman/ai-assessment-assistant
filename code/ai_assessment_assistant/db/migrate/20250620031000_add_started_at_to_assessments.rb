class AddStartedAtToAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :assessments, :started_at, :datetime
  end
end

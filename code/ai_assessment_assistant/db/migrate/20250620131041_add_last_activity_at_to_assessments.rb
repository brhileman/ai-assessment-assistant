class AddLastActivityAtToAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :assessments, :last_activity_at, :datetime
  end
end

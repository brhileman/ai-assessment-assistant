class CreateAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :assessments do |t|
      t.references :stakeholder, null: false, foreign_key: true
      t.text :full_transcript
      t.datetime :completed_at

      t.timestamps
    end
    
    # Remove the existing index and add unique constraint
    remove_index :assessments, :stakeholder_id
    add_index :assessments, :stakeholder_id, unique: true
    add_index :assessments, :completed_at
  end
end

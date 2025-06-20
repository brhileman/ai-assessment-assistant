class CreateStakeholders < ActiveRecord::Migration[8.0]
  def change
    create_table :stakeholders do |t|
      t.string :name, null: false, limit: 100
      t.string :email, null: false
      t.string :invitation_token, null: false
      t.references :company, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
    
    # Add indexes for performance and uniqueness constraints
    add_index :stakeholders, :invitation_token, unique: true
    add_index :stakeholders, [:company_id, :email], unique: true
    add_index :stakeholders, :status
  end
end

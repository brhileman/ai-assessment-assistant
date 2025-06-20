class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false, limit: 100
      t.text :custom_instructions, limit: 1000

      t.timestamps
    end
    
    # Add indexes for performance
    add_index :companies, :name
  end
end

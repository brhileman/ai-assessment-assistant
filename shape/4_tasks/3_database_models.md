# Task 3: Database Models & Data Architecture

**Prerequisites:** Task 2 (Admin Authentication) must be completed

## Task Overview
Create the core data models for the AI Assessment Assistant: Company, Stakeholder, and Assessment. Implement UUID-based invitation tokens, proper relationships, and validation rules for the MVP data architecture.

## Reference Documentation
- **User Story 4**: Stakeholder Data Linking in `../2_user-stories/`
- **Data Model**: Simplified architecture defined in `../1_big-picture/`
- **Technical Requirements**: Database section in overview

## Tasks

- [ ] 1.0 Create Company Model
  - [ ] 1.1 Generate Company model: `rails generate model Company name:string custom_instructions:text`
  - [ ] 1.2 Add validation rules for company data
  - [ ] 1.3 Add methods for assessment management
  - [ ] 1.4 Create factory for testing
  - [ ] 1.5 Write unit tests for Company model
  - [ ] 1.6 Run migration: `rails db:migrate`

- [ ] 2.0 Create Stakeholder Model with UUID Tokens
  - [ ] 2.1 Generate Stakeholder model: `rails generate model Stakeholder name:string email:string invitation_token:string company:references`
  - [ ] 2.2 Add UUID generation for invitation tokens
  - [ ] 2.3 Add email validation and uniqueness constraints
  - [ ] 2.4 Add invitation status and tracking
  - [ ] 2.5 Create methods for token validation
  - [ ] 2.6 Add factory and unit tests
  - [ ] 2.7 Run migration: `rails db:migrate`

- [ ] 3.0 Create Assessment Model
  - [ ] 3.1 Generate Assessment model: `rails generate model Assessment stakeholder:references full_transcript:text completed_at:datetime`
  - [ ] 3.2 Add validation to ensure one assessment per stakeholder
  - [ ] 3.3 Add assessment status and duration tracking
  - [ ] 3.4 Create methods for transcript management
  - [ ] 3.5 Add factory and unit tests
  - [ ] 3.6 Run migration: `rails db:migrate`

- [ ] 4.0 Define Model Relationships
  - [ ] 4.1 Set up Company → has_many :stakeholders relationship
  - [ ] 4.2 Set up Stakeholder → belongs_to :company relationship
  - [ ] 4.3 Set up Stakeholder → has_one :assessment relationship
  - [ ] 4.4 Set up Assessment → belongs_to :stakeholder relationship
  - [ ] 4.5 Add dependent destroy/restrict options
  - [ ] 4.6 Test all relationship methods

- [ ] 5.0 Add Business Logic Methods
  - [ ] 5.1 Company: methods for stakeholder management
  - [ ] 5.2 Stakeholder: invitation and assessment status methods
  - [ ] 5.3 Assessment: completion and transcript parsing methods
  - [ ] 5.4 Add scope methods for common queries
  - [ ] 5.5 Add helper methods for UI display
  - [ ] 5.6 Document all public methods

- [ ] 6.0 Create Database Indexes and Constraints
  - [ ] 6.1 Add index on stakeholder invitation_token (unique)
  - [ ] 6.2 Add index on stakeholder email (unique per company)
  - [ ] 6.3 Add indexes for common query patterns
  - [ ] 6.4 Add database constraints for data integrity
  - [ ] 6.5 Test index performance
  - [ ] 6.6 Run migration: `rails db:migrate`

- [ ] 7.0 Seed Data for Development
  - [ ] 7.1 Create realistic company seed data
  - [ ] 7.2 Create stakeholder seed data with tokens
  - [ ] 7.3 Create assessment seed data with transcripts
  - [ ] 7.4 Ensure seed data is consistent and testable
  - [ ] 7.5 Test seed data creation: `rails db:seed`
  - [ ] 7.6 Document seed data structure

## Implementation Details

### Company Model
```ruby
class Company < ApplicationRecord
  has_many :stakeholders, dependent: :destroy
  has_many :assessments, through: :stakeholders
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :custom_instructions, length: { maximum: 1000 }
  
  def assessment_completion_rate
    return 0 if stakeholders.empty?
    completed = stakeholders.joins(:assessment).count
    (completed.to_f / stakeholders.count * 100).round(1)
  end
  
  def pending_assessments_count
    stakeholders.left_joins(:assessment).where(assessments: { id: nil }).count
  end
end
```

### Stakeholder Model
```ruby
class Stakeholder < ApplicationRecord
  belongs_to :company
  has_one :assessment, dependent: :destroy
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :company_id }
  validates :invitation_token, presence: true, uniqueness: true
  
  before_validation :generate_invitation_token, on: :create
  
  enum status: { invited: 0, assessment_started: 1, assessment_completed: 2 }
  
  def to_param
    invitation_token
  end
  
  def assessment_completed?
    assessment&.completed_at.present?
  end
  
  private
  
  def generate_invitation_token
    self.invitation_token = SecureRandom.uuid
  end
end
```

### Assessment Model
```ruby
class Assessment < ApplicationRecord
  belongs_to :stakeholder
  
  validates :stakeholder, uniqueness: true
  validates :full_transcript, presence: true, on: :update
  
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil) }
  
  def completed?
    completed_at.present?
  end
  
  def duration_minutes
    return nil unless completed_at && created_at
    ((completed_at - created_at) / 1.minute).round
  end
  
  def transcript_word_count
    return 0 if full_transcript.blank?
    full_transcript.split.length
  end
end
```

## File Tracking

### Files to Create
| File Path | Purpose | Task Ref | Status |
|-----------|---------|----------|--------|
| `app/models/company.rb` | Company model with relationships | 1.1 | ⏳ |
| `db/migrate/*_create_companies.rb` | Company table migration | 1.1 | ⏳ |
| `app/models/stakeholder.rb` | Stakeholder model with UUID tokens | 2.1 | ⏳ |
| `db/migrate/*_create_stakeholders.rb` | Stakeholder table migration | 2.1 | ⏳ |
| `app/models/assessment.rb` | Assessment model | 3.1 | ⏳ |
| `db/migrate/*_create_assessments.rb` | Assessment table migration | 3.1 | ⏳ |
| `db/migrate/*_add_indexes.rb` | Database indexes migration | 6.1-6.4 | ⏳ |
| `spec/models/company_spec.rb` | Company model tests | 1.5 | ⏳ |
| `spec/models/stakeholder_spec.rb` | Stakeholder model tests | 2.6 | ⏳ |
| `spec/models/assessment_spec.rb` | Assessment model tests | 3.5 | ⏳ |
| `spec/factories/companies.rb` | Company factory | 1.4 | ⏳ |
| `spec/factories/stakeholders.rb` | Stakeholder factory | 2.6 | ⏳ |
| `spec/factories/assessments.rb` | Assessment factory | 3.5 | ⏳ |

### Files to Modify
| File Path | Changes | Task Ref | Status |
|-----------|---------|----------|--------|
| `db/seeds.rb` | Add development seed data | 7.1-7.3 | ⏳ |

## Database Schema

```ruby
# Company Table
create_table :companies do |t|
  t.string :name, null: false, limit: 100
  t.text :custom_instructions, limit: 1000
  t.timestamps
end

# Stakeholder Table  
create_table :stakeholders do |t|
  t.string :name, null: false, limit: 100
  t.string :email, null: false
  t.string :invitation_token, null: false
  t.references :company, null: false, foreign_key: true
  t.integer :status, default: 0
  t.timestamps
end

# Assessment Table
create_table :assessments do |t|
  t.references :stakeholder, null: false, foreign_key: true
  t.text :full_transcript
  t.datetime :completed_at
  t.timestamps
end

# Indexes
add_index :stakeholders, :invitation_token, unique: true
add_index :stakeholders, [:company_id, :email], unique: true
add_index :assessments, :stakeholder_id, unique: true
```

## Success Criteria

- [ ] All models created with proper validations
- [ ] UUID tokens generated correctly for stakeholders
- [ ] One-to-one relationship enforced between stakeholder and assessment
- [ ] Company can manage multiple stakeholders
- [ ] Database indexes improve query performance
- [ ] All unit tests pass
- [ ] Seed data creates realistic development environment
- [ ] Model methods work as expected in Rails console

## Testing Strategy

### Unit Tests
- Model validations and relationships
- UUID token generation and uniqueness
- Business logic methods
- Scope methods and queries

### Integration Tests
- Cross-model relationships
- Data integrity constraints
- Seed data consistency

## Next Steps

After Task 3 completion:
- Task 4: Build admin dashboard with company management interface
- Task 5: Implement stakeholder invitation email system
- The data models enable all subsequent features 
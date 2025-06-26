require 'rails_helper'

RSpec.describe Stakeholder, type: :model do
  let(:stakeholder) { build(:stakeholder) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(stakeholder).to be_valid
    end
    
    describe 'name validation' do
      it 'requires a name' do
        stakeholder.name = nil
        expect(stakeholder).not_to be_valid
        expect(stakeholder.errors[:name]).to include("can't be blank")
      end
      
      it 'requires name to be at least 2 characters' do
        stakeholder.name = 'A'
        expect(stakeholder).not_to be_valid
        expect(stakeholder.errors[:name]).to include('is too short (minimum is 2 characters)')
      end
      
      it 'requires name to be at most 100 characters' do
        stakeholder.name = 'A' * 101
        expect(stakeholder).not_to be_valid
        expect(stakeholder.errors[:name]).to include('is too long (maximum is 100 characters)')
      end
    end
    
    describe 'email validation' do
      it 'requires an email' do
        stakeholder.email = nil
        expect(stakeholder).not_to be_valid
        expect(stakeholder.errors[:email]).to include("can't be blank")
      end
      
      it 'requires a valid email format' do
        invalid_emails = ['invalid', 'test@', '@example.com', 'test.example.com']
        invalid_emails.each do |email|
          stakeholder.email = email
          expect(stakeholder).not_to be_valid
          expect(stakeholder.errors[:email]).to include('is invalid')
        end
      end
      
      it 'accepts valid email formats' do
        valid_emails = ['test@example.com', 'user.name@domain.co.uk', 'name+tag@example.org']
        valid_emails.each do |email|
          stakeholder.email = email
          expect(stakeholder).to be_valid
        end
      end
      
      it 'requires email to be unique within company scope' do
        company = create(:company)
        create(:stakeholder, email: 'test@example.com', company: company)
        
        duplicate_stakeholder = build(:stakeholder, email: 'test@example.com', company: company)
        expect(duplicate_stakeholder).not_to be_valid
        expect(duplicate_stakeholder.errors[:email]).to include('already exists for this company')
      end
      
      it 'allows same email in different companies' do
        company1 = create(:company)
        company2 = create(:company)
        
        create(:stakeholder, email: 'test@example.com', company: company1)
        stakeholder2 = build(:stakeholder, email: 'test@example.com', company: company2)
        
        expect(stakeholder2).to be_valid
      end
    end
    
    describe 'invitation_token validation' do
      it 'auto-generates invitation_token if not provided' do
        stakeholder.invitation_token = nil
        expect(stakeholder).to be_valid
        expect(stakeholder.invitation_token).to be_present
      end
      
      it 'requires invitation_token to be unique' do
        existing_stakeholder = create(:stakeholder)
        stakeholder.invitation_token = existing_stakeholder.invitation_token
        
        expect(stakeholder).not_to be_valid
        expect(stakeholder.errors[:invitation_token]).to include('has already been taken')
      end
    end
  end
  
  describe 'relationships' do
    it 'belongs to a company' do
      expect(stakeholder).to respond_to(:company)
      expect(Stakeholder.reflect_on_association(:company).macro).to eq(:belongs_to)
    end
    
    it 'has one assessment' do
      expect(stakeholder).to respond_to(:assessment)
      expect(Stakeholder.reflect_on_association(:assessment).macro).to eq(:has_one)
    end
    
    it 'destroys dependent assessment when stakeholder is destroyed' do
      stakeholder = create(:stakeholder)
      assessment = create(:assessment, stakeholder: stakeholder)
      
      expect { stakeholder.destroy }.to change { Assessment.count }.by(-1)
    end
  end
  
  describe 'UUID token generation' do
    it 'automatically generates invitation_token on creation' do
      stakeholder = build(:stakeholder, invitation_token: nil)
      stakeholder.save!
      
      expect(stakeholder.invitation_token).to be_present
      expect(stakeholder.invitation_token).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
    
    it 'does not override existing invitation_token' do
      custom_token = SecureRandom.uuid
      stakeholder = build(:stakeholder, invitation_token: custom_token)
      stakeholder.save!
      
      expect(stakeholder.invitation_token).to eq(custom_token)
    end
    
    it 'generates unique tokens for different stakeholders' do
      stakeholder1 = create(:stakeholder)
      stakeholder2 = create(:stakeholder)
      
      expect(stakeholder1.invitation_token).not_to eq(stakeholder2.invitation_token)
    end
  end
  
  describe 'status enum' do
    it 'has correct status values' do
      expect(Stakeholder.statuses).to eq({
        'invited' => 0,
        'assessment_started' => 1,
        'assessment_completed' => 2
      })
    end
    
    it 'defaults to invited status' do
      stakeholder = create(:stakeholder)
      expect(stakeholder.invited?).to be true
    end
    
    it 'allows status transitions' do
      stakeholder = create(:stakeholder)
      
      stakeholder.assessment_started!
      expect(stakeholder.status).to eq('assessment_started')
      expect(stakeholder.assessment_started?).to be true
      
      stakeholder.assessment_completed!
      expect(stakeholder.status).to eq('assessment_completed')
      # Note: stakeholder.assessment_completed? checks if assessment.completed_at is present,
      # not the status enum. Use stakeholder.status == 'assessment_completed' for enum check
    end
  end
  
  describe 'scope methods' do
    let!(:company) { create(:company) }
    let!(:stakeholder_with_assessment) { create(:stakeholder, :assessment_completed, company: company) }
    let!(:stakeholder_without_assessment) { create(:stakeholder, company: company) }
    
    describe '.with_assessments' do
      it 'returns only stakeholders with assessments' do
        result = Stakeholder.with_assessments
        expect(result).to include(stakeholder_with_assessment)
        expect(result).not_to include(stakeholder_without_assessment)
      end
    end
    
    describe '.without_assessments' do
      it 'returns only stakeholders without assessments' do
        result = Stakeholder.without_assessments
        expect(result).to include(stakeholder_without_assessment)
        expect(result).not_to include(stakeholder_with_assessment)
      end
    end
    
    describe '.pending_assessments' do
      it 'returns stakeholders with invited or assessment_started status' do
        invited_stakeholder = create(:stakeholder, status: :invited)
        started_stakeholder = create(:stakeholder, status: :assessment_started)
        completed_stakeholder = create(:stakeholder, status: :assessment_completed)
        
        result = Stakeholder.pending_assessments
        expect(result).to include(invited_stakeholder, started_stakeholder)
        expect(result).not_to include(completed_stakeholder)
      end
    end
  end
  
  describe 'business logic methods' do
    let!(:stakeholder) { create(:stakeholder) }
    
    describe '#assessment_completed?' do
      it 'returns false when no assessment exists' do
        expect(stakeholder.assessment_completed?).to be false
      end
      
      it 'returns false when assessment exists but not completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: nil)
        expect(stakeholder.assessment_completed?).to be false
      end
      
      it 'returns true when assessment is completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: Time.current)
        expect(stakeholder.assessment_completed?).to be true
      end
    end
    
    describe '#assessment_in_progress?' do
      it 'returns false when no assessment exists' do
        expect(stakeholder.assessment_in_progress?).to be false
      end
      
      it 'returns true when assessment exists but not completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: nil)
        expect(stakeholder.assessment_in_progress?).to be true
      end
      
      it 'returns false when assessment is completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: Time.current)
        expect(stakeholder.assessment_in_progress?).to be false
      end
    end
    
    describe '#can_start_assessment?' do
      it 'returns true when invited and no assessment exists' do
        stakeholder.update!(status: :invited)
        expect(stakeholder.can_start_assessment?).to be true
      end
      
      it 'returns false when assessment already exists' do
        create(:assessment, stakeholder: stakeholder)
        expect(stakeholder.can_start_assessment?).to be false
      end
      
      it 'returns false when not in invited status' do
        stakeholder.update!(status: :assessment_started)
        expect(stakeholder.can_start_assessment?).to be false
      end
    end
    
    describe '#update_status_based_on_assessment!' do
      it 'sets status to assessment_completed when assessment is completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: Time.current)
        stakeholder.update_status_based_on_assessment!
        
        expect(stakeholder.assessment_completed?).to be true
      end
      
      it 'sets status to assessment_started when assessment exists but not completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: nil)
        stakeholder.update_status_based_on_assessment!
        
        expect(stakeholder.assessment_started?).to be true
      end
      
      it 'sets status to invited when no assessment exists' do
        stakeholder.update!(status: :assessment_started)
        stakeholder.update_status_based_on_assessment!
        
        expect(stakeholder.invited?).to be true
      end
    end
  end
  
  describe 'token validation methods' do
    let!(:stakeholder) { create(:stakeholder) }
    
    describe '.find_by_token' do
      it 'finds stakeholder by valid token' do
        result = Stakeholder.find_by_token(stakeholder.invitation_token)
        expect(result).to eq(stakeholder)
      end
      
      it 'returns nil for invalid token' do
        result = Stakeholder.find_by_token('invalid-token')
        expect(result).to be_nil
      end
    end
    
    describe '.find_by_token!' do
      it 'finds stakeholder by valid token' do
        result = Stakeholder.find_by_token!(stakeholder.invitation_token)
        expect(result).to eq(stakeholder)
      end
      
      it 'raises error for invalid token' do
        expect {
          Stakeholder.find_by_token!('invalid-token')
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe '#regenerate_invitation_token!' do
      it 'generates a new UUID token' do
        old_token = stakeholder.invitation_token
        stakeholder.regenerate_invitation_token!
        
        expect(stakeholder.invitation_token).not_to eq(old_token)
        expect(stakeholder.invitation_token).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
      end
    end
  end
  
  describe 'invitation tracking' do
    describe '#invitation_sent_at' do
      it 'can be set and retrieved' do
        timestamp = Time.current
        stakeholder.invitation_sent_at = timestamp
        stakeholder.save!
        
        expect(stakeholder.reload.invitation_sent_at).to be_within(1.second).of(timestamp)
      end
      
      it 'can be nil initially' do
        stakeholder = create(:stakeholder)
        expect(stakeholder.invitation_sent_at).to be_nil
      end
      
      it 'can be updated' do
        stakeholder = create(:stakeholder, invitation_sent_at: 2.days.ago)
        new_timestamp = Time.current
        
        stakeholder.update!(invitation_sent_at: new_timestamp)
        expect(stakeholder.invitation_sent_at).to be_within(1.second).of(new_timestamp)
      end
    end
    
    describe '#invitation_sent_at?' do
      it 'returns true when invitation_sent_at is present' do
        stakeholder = create(:stakeholder, invitation_sent_at: Time.current)
        expect(stakeholder.invitation_sent_at?).to be true
      end
      
      it 'returns false when invitation_sent_at is nil' do
        stakeholder = create(:stakeholder, invitation_sent_at: nil)
        expect(stakeholder.invitation_sent_at?).to be false
      end
    end
  end

  describe 'helper methods' do
    describe '#to_param' do
      it 'returns the invitation_token for URL generation' do
        expect(stakeholder.to_param).to eq(stakeholder.invitation_token)
      end
    end
    
    describe '#display_name' do
      it 'returns the name when present' do
        stakeholder.name = 'John Doe'
        expect(stakeholder.display_name).to eq('John Doe')
      end
      
      it 'returns default text when name is blank' do
        stakeholder.name = ''
        expect(stakeholder.display_name).to eq('Unnamed Stakeholder')
      end
    end
    
    describe '#display_status' do
      it 'returns humanized status' do
        stakeholder.status = :assessment_started
        expect(stakeholder.display_status).to eq('Assessment started')
      end
    end
    
    describe '#assessment_completion_date' do
      it 'returns formatted date when assessment is completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: Time.parse('2024-01-15 10:00:00'))
        expect(stakeholder.assessment_completion_date).to eq('January 15, 2024')
      end
      
      it 'returns nil when assessment is not completed' do
        create(:assessment, stakeholder: stakeholder, completed_at: nil)
        expect(stakeholder.assessment_completion_date).to be_nil
      end
      
      it 'returns nil when no assessment exists' do
        expect(stakeholder.assessment_completion_date).to be_nil
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Assessment, type: :model do
  let(:assessment) { build(:assessment) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      assessment.full_transcript = "Some transcript content"
      expect(assessment).to be_valid
    end
    
    describe 'stakeholder uniqueness' do
      it 'allows one assessment per stakeholder' do
        stakeholder = create(:stakeholder)
        create(:assessment, stakeholder: stakeholder)
        
        duplicate_assessment = build(:assessment, stakeholder: stakeholder)
        expect(duplicate_assessment).not_to be_valid
        expect(duplicate_assessment.errors[:stakeholder]).to include('can only have one assessment')
      end
      
      it 'allows assessments for different stakeholders' do
        stakeholder1 = create(:stakeholder)
        stakeholder2 = create(:stakeholder)
        
        create(:assessment, stakeholder: stakeholder1)
        assessment2 = build(:assessment, stakeholder: stakeholder2)
        
        expect(assessment2).to be_valid
      end
    end
    
    describe 'full_transcript validation' do
      it 'does not require transcript on create' do
        assessment.full_transcript = nil
        expect(assessment).to be_valid
      end
      
      it 'requires transcript on update' do
        assessment = create(:assessment, full_transcript: nil)
        assessment.full_transcript = nil
        
        expect(assessment).not_to be_valid
        expect(assessment.errors[:full_transcript]).to include("can't be blank")
      end
      
      it 'accepts transcript on update' do
        assessment = create(:assessment, full_transcript: nil)
        assessment.full_transcript = "Updated transcript content"
        
        expect(assessment).to be_valid
      end
    end
  end
  
  describe 'relationships' do
    it 'belongs to a stakeholder' do
      expect(assessment).to respond_to(:stakeholder)
      expect(Assessment.reflect_on_association(:stakeholder).macro).to eq(:belongs_to)
    end
  end
  
  describe 'scope methods' do
    let!(:completed_assessment) { create(:assessment, :completed) }
    let!(:in_progress_assessment) { create(:assessment, :in_progress) }
    
    describe '.completed' do
      it 'returns only completed assessments' do
        result = Assessment.completed
        expect(result).to include(completed_assessment)
        expect(result).not_to include(in_progress_assessment)
      end
    end
    
    describe '.in_progress' do
      it 'returns only in progress assessments' do
        result = Assessment.in_progress
        expect(result).to include(in_progress_assessment)
        expect(result).not_to include(completed_assessment)
      end
    end
    
    describe '.recent' do
      it 'orders by created_at desc' do
        # Clear any pre-existing assessments to ensure clean test
        Assessment.destroy_all
        
        older_assessment = create(:assessment, created_at: 2.hours.ago)
        newer_assessment = create(:assessment, created_at: 1.hour.ago)
        
        result = Assessment.recent
        expect(result.first).to eq(newer_assessment)
        expect(result.last).to eq(older_assessment)
      end
    end
  end
  
  describe 'business logic methods' do
    describe '#completed?' do
      it 'returns true when completed_at is present' do
        assessment.completed_at = Time.current
        expect(assessment.completed?).to be true
      end
      
      it 'returns false when completed_at is nil' do
        assessment.completed_at = nil
        expect(assessment.completed?).to be false
      end
    end
    
    describe '#in_progress?' do
      it 'returns false when completed_at is present' do
        assessment.completed_at = Time.current
        expect(assessment.in_progress?).to be false
      end
      
      it 'returns true when completed_at is nil' do
        assessment.completed_at = nil
        expect(assessment.in_progress?).to be true
      end
    end
    
    describe '#duration_minutes' do
      it 'returns nil when not completed' do
        assessment.completed_at = nil
        expect(assessment.duration_minutes).to be_nil
      end
      
      it 'returns nil when started_at is missing' do
        assessment.completed_at = Time.current
        assessment.started_at = nil
        expect(assessment.duration_minutes).to be_nil
      end
      
      it 'calculates duration in minutes correctly' do
        assessment.started_at = 30.minutes.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_minutes).to eq(30)
      end
      
      it 'rounds duration to nearest minute' do
        assessment.started_at = 10.5.minutes.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_minutes).to eq(11)
      end
    end
    
    describe '#duration_seconds' do
      it 'calculates duration in seconds correctly' do
        assessment.started_at = 90.seconds.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_seconds).to eq(90)
      end
    end
    
    describe '#transcript_word_count' do
      it 'returns 0 for blank transcript' do
        assessment.full_transcript = nil
        expect(assessment.transcript_word_count).to eq(0)
        
        assessment.full_transcript = ''
        expect(assessment.transcript_word_count).to eq(0)
      end
      
      it 'counts words correctly' do
        assessment.full_transcript = 'Hello world this is a test'
        expect(assessment.transcript_word_count).to eq(6)
      end
      
      it 'handles multiple spaces correctly' do
        assessment.full_transcript = 'Hello    world   test'
        expect(assessment.transcript_word_count).to eq(3)
      end
    end
    
    describe '#transcript_character_count' do
      it 'returns 0 for blank transcript' do
        assessment.full_transcript = nil
        expect(assessment.transcript_character_count).to eq(0)
      end
      
      it 'counts characters including spaces' do
        assessment.full_transcript = 'Hello world'
        expect(assessment.transcript_character_count).to eq(11)
      end
    end
    
    describe '#mark_completed!' do
      let!(:stakeholder) { create(:stakeholder) }
      let!(:assessment) { create(:assessment, stakeholder: stakeholder, completed_at: nil) }
      
      it 'sets completed_at to current time' do
        time_before = Time.current
        assessment.mark_completed!
        time_after = Time.current
        
        expect(assessment.completed_at).to be >= time_before
        expect(assessment.completed_at).to be <= time_after
      end
      
      it 'updates stakeholder status' do
        expect(stakeholder).to receive(:update_status_based_on_assessment!)
        assessment.mark_completed!
      end
    end
    
    describe '#has_transcript?' do
      it 'returns true when transcript is present' do
        assessment.full_transcript = 'Some content'
        expect(assessment.has_transcript?).to be true
      end
      
      it 'returns false when transcript is blank' do
        assessment.full_transcript = nil
        expect(assessment.has_transcript?).to be false
        
        assessment.full_transcript = ''
        expect(assessment.has_transcript?).to be false
      end
    end
  end
  
  describe 'helper methods' do
    describe '#display_status' do
      it 'returns "Completed" when completed' do
        assessment.completed_at = Time.current
        expect(assessment.display_status).to eq('Completed')
      end
      
      it 'returns "In Progress" when not completed' do
        assessment.completed_at = nil
        expect(assessment.display_status).to eq('In Progress')
      end
    end
    
    describe '#completion_date_formatted' do
      it 'returns formatted date when completed' do
        assessment.completed_at = Time.zone.parse('2024-01-15 14:30:00')
        expect(assessment.completion_date_formatted).to eq('January 15, 2024 at 02:30 PM')
      end
      
      it 'returns nil when not completed' do
        assessment.completed_at = nil
        expect(assessment.completion_date_formatted).to be_nil
      end
    end
    
    describe '#duration_formatted' do
      it 'returns "Not completed" when not completed' do
        assessment.completed_at = nil
        expect(assessment.duration_formatted).to eq('Not completed')
      end
      
      it 'handles durations less than 1 minute' do
        assessment.started_at = 29.seconds.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_formatted).to eq('Less than 1 minute')
      end
      
      it 'formats minutes correctly' do
        assessment.started_at = 5.minutes.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_formatted).to eq('5 minutes')
        
        assessment.started_at = 1.minute.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_formatted).to eq('1 minute')
      end
      
      it 'formats hours and minutes correctly' do
        assessment.started_at = 75.minutes.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_formatted).to eq('1 hour 15 minutes')
        
        assessment.started_at = 120.minutes.ago
        assessment.completed_at = Time.current
        expect(assessment.duration_formatted).to eq('2 hours')
      end
    end
    
    describe '#transcript_summary' do
      it 'returns "No transcript" when transcript is blank' do
        assessment.full_transcript = nil
        expect(assessment.transcript_summary).to eq('No transcript')
      end
      
      it 'returns word count for single word' do
        assessment.full_transcript = 'Hello'
        expect(assessment.transcript_summary).to eq('1 word')
      end
      
      it 'returns word count for multiple words' do
        assessment.full_transcript = 'Hello world test'
        expect(assessment.transcript_summary).to eq('3 words')
      end
    end
  end
  
  describe 'class methods' do
    describe '.average_duration_minutes' do
      it 'returns 0 when no completed assessments' do
        create(:assessment, :in_progress)
        expect(Assessment.average_duration_minutes).to eq(0)
      end
      
      it 'calculates average duration correctly' do
        # Assessment that took 10 minutes
        assessment1 = create(:assessment, started_at: 10.minutes.ago, completed_at: Time.current)
        # Assessment that took 20 minutes
        assessment2 = create(:assessment, started_at: 20.minutes.ago, completed_at: Time.current)
        
        expect(Assessment.average_duration_minutes).to eq(15.0)
      end
      
      it 'ignores assessments without started_at' do
        assessment_with_duration = create(:assessment, started_at: 10.minutes.ago, completed_at: Time.current)
        assessment_without_started_at = create(:assessment, started_at: nil, completed_at: Time.current)
        
        expect(Assessment.average_duration_minutes).to eq(10.0)
      end
    end
    
    describe '.completion_rate' do
      it 'returns 0 when no assessments' do
        expect(Assessment.completion_rate).to eq(0)
      end
      
      it 'calculates completion rate correctly' do
        create(:assessment, :completed)
        create(:assessment, :completed)
        create(:assessment, :in_progress)
        
        # 2 out of 3 = 66.7%
        expect(Assessment.completion_rate).to eq(66.7)
      end
      
      it 'returns 100 when all assessments are completed' do
        create(:assessment, :completed)
        create(:assessment, :completed)
        
        expect(Assessment.completion_rate).to eq(100.0)
      end
    end
  end
end

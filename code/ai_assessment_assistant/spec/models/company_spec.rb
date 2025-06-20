require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { build(:company) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(company).to be_valid
    end
    
    describe 'name validation' do
      it 'requires a name' do
        company.name = nil
        expect(company).not_to be_valid
        expect(company.errors[:name]).to include("can't be blank")
      end
      
      it 'requires name to be at least 2 characters' do
        company.name = 'A'
        expect(company).not_to be_valid
        expect(company.errors[:name]).to include('is too short (minimum is 2 characters)')
      end
      
      it 'requires name to be at most 100 characters' do
        company.name = 'A' * 101
        expect(company).not_to be_valid
        expect(company.errors[:name]).to include('is too long (maximum is 100 characters)')
      end
      
      it 'accepts valid names' do
        valid_names = ['AB', 'Tech Corp', 'A' * 100]
        valid_names.each do |name|
          company.name = name
          expect(company).to be_valid
        end
      end
    end
    
    describe 'custom_instructions validation' do
      it 'allows nil custom_instructions' do
        company.custom_instructions = nil
        expect(company).to be_valid
      end
      
      it 'allows empty custom_instructions' do
        company.custom_instructions = ''
        expect(company).to be_valid
      end
      
      it 'requires custom_instructions to be at most 1000 characters' do
        company.custom_instructions = 'A' * 1001
        expect(company).not_to be_valid
        expect(company.errors[:custom_instructions]).to include('is too long (maximum is 1000 characters)')
      end
      
      it 'accepts valid custom_instructions' do
        company.custom_instructions = 'A' * 1000
        expect(company).to be_valid
      end
    end
  end
  
  describe 'relationships' do
    it 'has many stakeholders' do
      expect(company).to respond_to(:stakeholders)
      expect(Company.reflect_on_association(:stakeholders).macro).to eq(:has_many)
    end
    
    it 'has many assessments through stakeholders' do
      expect(company).to respond_to(:assessments)
      expect(Company.reflect_on_association(:assessments).macro).to eq(:has_many)
      expect(Company.reflect_on_association(:assessments).options[:through]).to eq(:stakeholders)
    end
    
    it 'destroys dependent stakeholders when company is destroyed' do
      company = create(:company)
      stakeholder = create(:stakeholder, company: company)
      
      expect { company.destroy }.to change { Stakeholder.count }.by(-1)
    end
  end
  
  describe 'business logic methods' do
    let!(:company) { create(:company) }
    
    describe '#assessment_completion_rate' do
      context 'when company has no stakeholders' do
        it 'returns 0' do
          expect(company.assessment_completion_rate).to eq(0)
        end
      end
      
      context 'when company has stakeholders' do
        let!(:stakeholder1) { create(:stakeholder, company: company) }
        let!(:stakeholder2) { create(:stakeholder, company: company) }
        let!(:stakeholder3) { create(:stakeholder, company: company) }
        
        it 'returns 0 when no assessments are completed' do
          expect(company.assessment_completion_rate).to eq(0)
        end
        
        it 'calculates correct completion rate with some completed assessments' do
          create(:assessment, stakeholder: stakeholder1, completed_at: Time.current)
          create(:assessment, stakeholder: stakeholder2, completed_at: Time.current)
          
          # 2 out of 3 = 66.7%
          expect(company.assessment_completion_rate).to eq(66.7)
        end
        
        it 'returns 100 when all assessments are completed' do
          create(:assessment, stakeholder: stakeholder1, completed_at: Time.current)
          create(:assessment, stakeholder: stakeholder2, completed_at: Time.current)
          create(:assessment, stakeholder: stakeholder3, completed_at: Time.current)
          
          expect(company.assessment_completion_rate).to eq(100.0)
        end
      end
    end
    
    describe '#pending_assessments_count' do
      it 'returns 0 when no stakeholders' do
        expect(company.pending_assessments_count).to eq(0)
      end
      
      it 'counts stakeholders without assessments' do
        create(:stakeholder, company: company)
        create(:stakeholder, company: company)
        stakeholder_with_assessment = create(:stakeholder, company: company)
        create(:assessment, stakeholder: stakeholder_with_assessment)
        
        expect(company.pending_assessments_count).to eq(2)
      end
    end
    
    describe '#completed_assessments_count' do
      it 'returns 0 when no completed assessments' do
        expect(company.completed_assessments_count).to eq(0)
      end
      
      it 'counts only completed assessments' do
        stakeholder1 = create(:stakeholder, company: company)
        stakeholder2 = create(:stakeholder, company: company)
        
        create(:assessment, stakeholder: stakeholder1, completed_at: Time.current)
        create(:assessment, stakeholder: stakeholder2, completed_at: nil)
        
        expect(company.completed_assessments_count).to eq(1)
      end
    end
    
    describe '#total_stakeholders_count' do
      it 'returns correct count of stakeholders' do
        create_list(:stakeholder, 3, company: company)
        expect(company.total_stakeholders_count).to eq(3)
      end
    end
  end
  
  describe 'scope methods' do
    let!(:company_with_stakeholders) { create(:company) }
    let!(:company_without_stakeholders) { create(:company) }
    
    before do
      create(:stakeholder, company: company_with_stakeholders)
    end
    
    describe '.with_stakeholders' do
      it 'returns only companies that have stakeholders' do
        result = Company.with_stakeholders
        expect(result).to include(company_with_stakeholders)
        expect(result).not_to include(company_without_stakeholders)
      end
    end
  end
  
  describe 'helper methods' do
    describe '#display_name' do
      it 'returns the name when present' do
        company.name = 'Test Company'
        expect(company.display_name).to eq('Test Company')
      end
      
      it 'returns default text when name is blank' do
        company.name = ''
        expect(company.display_name).to eq('Unnamed Company')
      end
      
      it 'returns default text when name is nil' do
        company.name = nil
        expect(company.display_name).to eq('Unnamed Company')
      end
    end
    
    describe '#has_custom_instructions?' do
      it 'returns true when custom_instructions are present' do
        company.custom_instructions = 'Some instructions'
        expect(company.has_custom_instructions?).to be true
      end
      
      it 'returns false when custom_instructions are blank' do
        company.custom_instructions = ''
        expect(company.has_custom_instructions?).to be false
      end
      
      it 'returns false when custom_instructions are nil' do
        company.custom_instructions = nil
        expect(company.has_custom_instructions?).to be false
      end
    end
  end
end

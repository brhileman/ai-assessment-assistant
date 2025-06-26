require 'rails_helper'

RSpec.describe "Admin::Assessments", type: :request do
  let!(:admin) { create(:admin) }
  let!(:company) { create(:company, name: "Test Company") }
  let!(:stakeholder) { create(:stakeholder, company: company, name: "John Doe") }
  let!(:assessment) { create(:assessment, stakeholder: stakeholder, completed_at: 1.day.ago, full_transcript: "Sample transcript") }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /index" do
    let!(:company2) { create(:company, name: "Company 2") }
    let!(:stakeholder2) { create(:stakeholder, company: company2, name: "Jane Smith") }
    let!(:assessment2) { create(:assessment, stakeholder: stakeholder2, completed_at: 2.days.ago, full_transcript: "Another transcript") }

    it "returns http success and shows all completed assessments" do
      get admin_assessments_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("All Assessments")
      expect(response.body).to include("John Doe")
      expect(response.body).to include("Jane Smith")
      expect(response.body).to include("Test Company")
      expect(response.body).to include("Company 2")
    end

    it "calculates stats correctly" do
      get admin_assessments_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("2") # total completed assessments
      expect(response.body).to include("Total Completed Assessments")
    end
  end

  describe "GET /show" do
    it "returns http success for completed assessment" do
      get admin_assessment_path(assessment)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Assessment Results")
      expect(response.body).to include("John Doe")
      expect(response.body).to include("Test Company")
      expect(response.body).to include("Sample transcript")
    end

    it "handles missing assessments gracefully" do
      get admin_assessment_path(99999)
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to include("Assessment not found")
    end
  end
end

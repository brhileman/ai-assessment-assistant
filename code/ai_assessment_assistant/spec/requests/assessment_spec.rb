require 'rails_helper'

RSpec.describe "Assessments", type: :request do
  let(:company) { create(:company, name: "Test Company", custom_instructions: "Test custom instructions") }
  let(:stakeholder) { create(:stakeholder, company: company, name: "John Doe", email: "john@example.com") }
  let(:invalid_token) { "invalid-token-123" }

  describe "GET /assessment/:token" do
    context "with valid token" do
      it "displays the assessment landing page" do
        get assessment_path(stakeholder.invitation_token)
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include("AI Assessment")
        expect(response.body).to include(company.name)
        expect(response.body).to include(stakeholder.name)
        expect(response.body).to include("Start Assessment")
      end

      it "shows company custom instructions when present" do
        get assessment_path(stakeholder.invitation_token)
        
        expect(response.body).to include("From #{company.name}:")
        expect(response.body).to include(company.custom_instructions)
      end

      it "shows Continue Assessment when assessment already started" do
        create(:assessment, stakeholder: stakeholder, started_at: 1.hour.ago)
        
        get assessment_path(stakeholder.invitation_token)
        
        expect(response.body).to include("Continue Assessment")
        # Check that the button text is "Continue Assessment", not "Start Assessment"
        expect(response.body).to include('Continue Assessment')
        expect(response.body).not_to match(/<button[^>]*>.*Start Assessment.*<\/button>/)
      end
    end

    context "with invalid token" do
      it "renders invalid token page with 404 status" do
        get assessment_path(invalid_token)
        
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Invalid Assessment Link")
      end
    end

    context "when assessment already completed" do
      it "renders assessment completed page" do
        create(:assessment, stakeholder: stakeholder, started_at: 2.hours.ago, completed_at: 1.hour.ago)
        
        get assessment_path(stakeholder.invitation_token)
        
        expect(response.body).to include("Assessment Complete")
        expect(response.body).to include("You've already completed your assessment")
      end
    end
  end

  describe "POST /assessment/:token/start" do
    context "with valid token and no existing assessment" do
      it "creates an assessment and redirects to voice assessment" do
        expect {
          post start_assessment_path(stakeholder.invitation_token)
        }.to change(Assessment, :count).by(1)
        
        expect(response).to redirect_to(voice_assessment_path(stakeholder.invitation_token))
        expect(stakeholder.reload.status).to eq("assessment_started")
        expect(stakeholder.assessment).to be_present
        expect(stakeholder.assessment.started_at).to be_present
      end
    end

    context "with invalid token" do
      it "renders invalid token page with 404 status" do
        post start_assessment_path(invalid_token)
        
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when assessment already completed" do
      it "renders assessment completed page" do
        create(:assessment, stakeholder: stakeholder, started_at: 2.hours.ago, completed_at: 1.hour.ago)
        
        post start_assessment_path(stakeholder.invitation_token)
        
        expect(response.body).to include("Assessment Complete")
      end
    end

    context "when stakeholder already has an assessment" do
      it "does not create duplicate assessment" do
        existing_assessment = create(:assessment, stakeholder: stakeholder, started_at: 1.hour.ago)
        
        expect {
          post start_assessment_path(stakeholder.invitation_token)
        }.not_to change(Assessment, :count)
        
        expect(response).to redirect_to(assessment_path(stakeholder.invitation_token))
        expect(flash[:alert]).to include("Unable to start assessment")
      end
    end
  end
end

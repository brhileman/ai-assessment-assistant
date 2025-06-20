require 'rails_helper'

RSpec.describe "VoiceAssessments", type: :request do
  let(:company) { create(:company) }
  let(:stakeholder) { create(:stakeholder, company: company) }
  let(:assessment) { create(:assessment, stakeholder: stakeholder) }

  describe "GET /voice/:token" do
    context "with valid stakeholder token and active assessment" do
      it "returns http success and shows voice assessment interface" do
        assessment # This line triggers the creation of the assessment
        get voice_assessment_path(stakeholder.invitation_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with valid token but no assessment started" do
      it "redirects to assessment landing page" do
        stakeholder_without_assessment = create(:stakeholder, company: company)
        get voice_assessment_path(stakeholder_without_assessment.invitation_token)
        expect(response).to redirect_to(assessment_path(stakeholder_without_assessment.invitation_token))
      end
    end

    context "with invalid token" do
      it "returns not found" do
        get voice_assessment_path("invalid-token")
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with completed assessment" do
      it "redirects to assessment completed page" do
        assessment.update!(completed_at: Time.current)
        get voice_assessment_path(stakeholder.invitation_token)
        expect(response).to redirect_to(assessment_completed_path(stakeholder.invitation_token))
      end
    end
  end

  describe "PATCH /voice/:token/complete" do
    it "completes the assessment and redirects" do
      assessment # Ensure assessment is created before the test
      patch complete_voice_assessment_path(stakeholder.invitation_token), 
            params: { final_transcript: "Test transcript" }
      
      assessment.reload
      expect(assessment.completed_at).to be_present
      expect(assessment.full_transcript).to eq("Test transcript")
      expect(response).to redirect_to(assessment_completed_path(stakeholder.invitation_token))
    end
  end
end

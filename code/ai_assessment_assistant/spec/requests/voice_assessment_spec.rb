require 'rails_helper'

RSpec.describe "VoiceAssessments", type: :request do
  let(:company) { create(:company) }
  let(:stakeholder) { create(:stakeholder, company: company) }
  let(:assessment) { create(:assessment, stakeholder: stakeholder) }

  describe "GET /voice/:token" do
    context "with valid stakeholder token and active assessment" do
      before do
        # Mock OpenAI service to prevent actual API calls and test initialization
        allow_any_instance_of(OpenaiRealtimeService).to receive(:create_conversation_session).and_return({
          session_id: 'test-session-id',
          ephemeral_token: 'test-token',
          api_endpoint: 'test-endpoint'
        })
      end

      it "returns http success and shows voice assessment interface" do
        assessment # This line triggers the creation of the assessment
        get voice_assessment_path(stakeholder.invitation_token)
        expect(response).to have_http_status(:success)
      end

      it "initializes OpenAI service without errors" do
        assessment
        expect {
          get voice_assessment_path(stakeholder.invitation_token)
        }.not_to raise_error
      end

      context "when OpenAI credentials are missing" do
        before do
          allow(ENV).to receive(:[]).and_call_original
          allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return(nil)
          allow(ENV).to receive(:[]).with('OPENAI_ORGANIZATION_ID').and_return(nil)
          allow(Rails.application.credentials).to receive(:dig).and_return(nil)
        end

        it "returns internal server error when credentials are missing" do
          assessment
          # In test environment, we need to handle the exception
          expect {
            get voice_assessment_path(stakeholder.invitation_token)
          }.to raise_error(RuntimeError, "OpenAI API key not found in environment variables or credentials")
        end
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

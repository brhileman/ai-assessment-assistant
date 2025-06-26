require 'rails_helper'

RSpec.describe "Assessments", type: :request do
  let(:company) { create(:company) }
  let(:stakeholder) { create(:stakeholder, company: company) }

  describe "GET /assessment/:token" do
    context "with valid stakeholder token and no assessment" do
      it "returns http success and shows assessment landing page" do
        get assessment_path(stakeholder.invitation_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with assessment already started" do
      it "shows landing page when assessment exists but not completed" do
        create(:assessment, stakeholder: stakeholder)
        get assessment_path(stakeholder.invitation_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with completed assessment" do
      it "redirects to assessment completed page" do
        assessment = create(:assessment, stakeholder: stakeholder, completed_at: Time.current)
        get assessment_path(stakeholder.invitation_token)
        expect(response).to redirect_to(assessment_completed_path(stakeholder.invitation_token))
      end
    end

    context "with invalid token" do
      it "returns not found" do
        get assessment_path("invalid-token")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /assessment/:token/start" do
    context "with valid stakeholder token" do
      context "when no assessment exists" do
        it "creates assessment and redirects to voice interface" do
          expect {
            post start_assessment_path(stakeholder.invitation_token)
          }.to change { Assessment.count }.by(1)
          
          assessment = Assessment.last
          expect(assessment.stakeholder).to eq(stakeholder)
          expect(stakeholder.reload.status).to eq("invited")
          expect(response).to redirect_to(voice_assessment_path(stakeholder.invitation_token))
        end
      end

      context "when assessment already exists" do
        let!(:existing_assessment) { create(:assessment, stakeholder: stakeholder) }
        
        it "does not create a new assessment and redirects to voice interface" do
          expect {
            post start_assessment_path(stakeholder.invitation_token)
          }.not_to change { Assessment.count }
          
          expect(response).to redirect_to(voice_assessment_path(stakeholder.invitation_token))
        end
      end
    end

    context "with invalid token" do
      it "returns not found" do
        post start_assessment_path("invalid-token")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /assessment/:token/completed" do
    context "with valid stakeholder and completed assessment" do
      it "returns http success and shows completion page" do
        assessment = create(:assessment, stakeholder: stakeholder, completed_at: Time.current)
        get assessment_completed_path(stakeholder.invitation_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid token" do
      it "returns not found" do
        get assessment_completed_path("invalid-token")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end 
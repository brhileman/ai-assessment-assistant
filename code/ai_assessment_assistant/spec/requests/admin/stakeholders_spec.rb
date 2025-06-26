require 'rails_helper'

RSpec.describe "Admin::Stakeholders", type: :request do
  let!(:admin) { create(:admin) }
  let!(:company) { create(:company) }

  before do
    sign_in admin, scope: :admin
    ActionMailer::Base.deliveries.clear
  end

  describe "GET /index" do
    let!(:company1) { create(:company, name: "Company 1") }
    let!(:company2) { create(:company, name: "Company 2") }
    let!(:stakeholder1) { create(:stakeholder, company: company1, name: "John Doe") }
    let!(:stakeholder2) { create(:stakeholder, company: company2, name: "Jane Smith") }
    let!(:assessment1) { create(:assessment, stakeholder: stakeholder1, completed_at: 1.day.ago) }
    let!(:assessment2) { create(:assessment, stakeholder: stakeholder2, completed_at: nil) }

    it "returns http success and shows all stakeholders" do
      get admin_stakeholders_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("All Stakeholders")
      expect(response.body).to include("John Doe")
      expect(response.body).to include("Jane Smith")
      expect(response.body).to include("Company 1")
      expect(response.body).to include("Company 2")
    end

    it "calculates stats correctly" do
      get admin_stakeholders_path
      expect(response).to have_http_status(:success)
      # Should show total stakeholders count
      expect(response.body).to include("2") # total stakeholders  
      expect(response.body).to include("Total Stakeholders")
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_admin_company_stakeholder_path(company)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Add New Stakeholder")
      expect(response.body).to include(company.name)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          stakeholder: {
            name: "John Doe",
            email: "john.doe@example.com"
          }
        }
      end

      it "creates a new stakeholder" do
        expect {
          post admin_company_stakeholders_path(company), params: valid_params
        }.to change(Stakeholder, :count).by(1)
        
        expect(response).to redirect_to(admin_company_path(company))
        expect(flash[:notice]).to include("John Doe has been added")
        
        # Verify stakeholder was created with assessment
        stakeholder = Stakeholder.last
        expect(stakeholder.company).to eq(company)
        expect(stakeholder.assessment).to be_present
        expect(stakeholder.status).to eq("invited")
      end

      it "sends invitation email and tracks invitation_sent_at" do
        expect {
          post admin_company_stakeholders_path(company), params: valid_params
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
        
        stakeholder = Stakeholder.last
        expect(stakeholder.invitation_sent_at).to be_present
        expect(stakeholder.invitation_sent_at).to be_within(1.second).of(Time.current)
        
        # Verify email content
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(["john.doe@example.com"])
        expect(email.subject).to include("invited")
      end

      context "when email delivery fails" do
        before do
          allow(AssessmentMailer).to receive(:stakeholder_invitation)
            .and_raise(StandardError.new("Email service error"))
        end

        it "creates stakeholder but shows email error message" do
          expect {
            post admin_company_stakeholders_path(company), params: valid_params
          }.to change(Stakeholder, :count).by(1)
          
          expect(response).to redirect_to(admin_company_path(company))
          expect(flash[:notice]).to include("there was an issue sending the invitation email")
          
          # Verify invitation_sent_at is not set when email fails
          stakeholder = Stakeholder.last
          expect(stakeholder.invitation_sent_at).to be_nil
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          stakeholder: {
            name: "",
            email: "invalid-email"
          }
        }
      end

      it "does not create a stakeholder and shows errors" do
        expect {
          post admin_company_stakeholders_path(company), params: invalid_params
        }.not_to change(Stakeholder, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:stakeholder) { create(:stakeholder, company: company) }

    it "deletes the stakeholder" do
      expect {
        delete admin_company_stakeholder_path(company, stakeholder.invitation_token)
      }.to change(Stakeholder, :count).by(-1)
      
      expect(response).to redirect_to(admin_company_path(company))
      expect(flash[:notice]).to include("has been removed")
    end
  end

  describe "POST /resend_invitation" do
    let!(:stakeholder) { create(:stakeholder, company: company, invitation_sent_at: 2.days.ago) }
    
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "sends invitation email again" do
      expect {
        post resend_invitation_admin_company_stakeholder_path(company, stakeholder.invitation_token)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      expect(response).to redirect_to(admin_company_path(company))
      expect(flash[:notice]).to include("Invitation email resent")
      expect(flash[:notice]).to include(stakeholder.name)
      expect(flash[:notice]).to include(stakeholder.email)
      
      # Verify email was sent to correct recipient
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([stakeholder.email])
    end

    it "updates invitation_sent_at timestamp" do
      old_timestamp = stakeholder.invitation_sent_at
      
      post resend_invitation_admin_company_stakeholder_path(company, stakeholder.invitation_token)
      
      stakeholder.reload
      expect(stakeholder.invitation_sent_at).to be > old_timestamp
      expect(stakeholder.invitation_sent_at).to be_within(1.second).of(Time.current)
    end

    context "when stakeholder has never been invited" do
      let!(:stakeholder) { create(:stakeholder, company: company, invitation_sent_at: nil) }

      it "sends invitation and sets invitation_sent_at" do
        post resend_invitation_admin_company_stakeholder_path(company, stakeholder.invitation_token)
        
        stakeholder.reload
        expect(stakeholder.invitation_sent_at).to be_present
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context "when email delivery fails" do
      before do
        allow(AssessmentMailer).to receive(:stakeholder_invitation)
          .and_raise(StandardError.new("SMTP error"))
      end

      it "shows error message and does not update timestamp" do
        old_timestamp = stakeholder.invitation_sent_at
        
        post resend_invitation_admin_company_stakeholder_path(company, stakeholder.invitation_token)
        
        expect(response).to redirect_to(admin_company_path(company))
        expect(flash[:alert]).to include("Failed to resend invitation email")
        
        stakeholder.reload
        expect(stakeholder.invitation_sent_at).to eq(old_timestamp)
      end
    end

    context "with invalid stakeholder token" do
      it "returns 404 not found" do
        post resend_invitation_admin_company_stakeholder_path(company, "invalid-token")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "when not authenticated" do
    before do
      sign_out admin
    end

    it "redirects to login" do
      get new_admin_company_stakeholder_path(company)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end


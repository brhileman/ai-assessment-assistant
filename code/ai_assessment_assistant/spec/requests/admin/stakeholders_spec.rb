require 'rails_helper'

RSpec.describe "Admin::Stakeholders", type: :request do
  let!(:admin) { create(:admin) }
  let!(:company) { create(:company) }

  before do
    sign_in admin, scope: :admin
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
        delete admin_company_stakeholder_path(company, stakeholder)
      }.to change(Stakeholder, :count).by(-1)
      
      expect(response).to redirect_to(admin_company_path(company))
      expect(flash[:notice]).to include("has been removed")
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


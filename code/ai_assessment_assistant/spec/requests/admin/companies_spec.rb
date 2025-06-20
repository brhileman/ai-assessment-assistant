require 'rails_helper'

RSpec.describe "Admin::Companies", type: :request do
  let(:admin) { create(:admin) }
  let(:company) { create(:company, name: "Test Company") }
  let(:valid_attributes) { { name: "New Company", custom_instructions: "Test instructions" } }
  let(:invalid_attributes) { { name: "" } }

  before do
    sign_in admin
  end

  describe "GET /admin/companies" do
    context "when authenticated" do
      it "returns http success" do
        get admin_companies_path
        expect(response).to have_http_status(:success)
      end

      it "displays companies" do
        company # create the company
        get admin_companies_path
        expect(response.body).to include(company.name)
      end

      it "handles search" do
        company # create the company
        get admin_companies_path, params: { search: "Test" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include(company.name)
      end
    end

    context "when not authenticated" do
      before { sign_out admin }
      
      it "redirects to login" do
        get admin_companies_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "GET /admin/companies/:id" do
    it "returns http success" do
      get admin_company_path(company)
      expect(response).to have_http_status(:success)
    end

    it "displays company details" do
      get admin_company_path(company)
      expect(response.body).to include(company.name)
    end
  end

  describe "GET /admin/companies/new" do
    it "returns http success" do
      get new_admin_company_path
      expect(response).to have_http_status(:success)
    end

    it "displays new company form" do
      get new_admin_company_path
      expect(response.body).to include("Add New Company")
    end
  end

  describe "POST /admin/companies" do
    context "with valid parameters" do
      it "creates a new company" do
        expect {
          post admin_companies_path, params: { company: valid_attributes }
        }.to change(Company, :count).by(1)
      end

      it "redirects to the created company" do
        post admin_companies_path, params: { company: valid_attributes }
        expect(response).to redirect_to(admin_company_path(Company.last))
      end

      it "sets success flash message" do
        post admin_companies_path, params: { company: valid_attributes }
        follow_redirect!
        expect(response.body).to include("Company was successfully created")
      end
    end

    context "with invalid parameters" do
      it "does not create a new company" do
        expect {
          post admin_companies_path, params: { company: invalid_attributes }
        }.to change(Company, :count).by(0)
      end

      it "renders the new template" do
        post admin_companies_path, params: { company: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /admin/companies/:id/edit" do
    it "returns http success" do
      get edit_admin_company_path(company)
      expect(response).to have_http_status(:success)
    end

    it "displays edit company form" do
      get edit_admin_company_path(company)
      expect(response.body).to include("Edit Company")
      expect(response.body).to include(company.name)
    end
  end

  describe "PATCH/PUT /admin/companies/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Company Name", custom_instructions: "Updated instructions" } }

      it "updates the requested company" do
        patch admin_company_path(company), params: { company: new_attributes }
        company.reload
        expect(company.name).to eq("Updated Company Name")
        expect(company.custom_instructions).to eq("Updated instructions")
      end

      it "redirects to the company" do
        patch admin_company_path(company), params: { company: new_attributes }
        expect(response).to redirect_to(admin_company_path(company))
      end

      it "sets success flash message" do
        patch admin_company_path(company), params: { company: new_attributes }
        follow_redirect!
        expect(response.body).to include("Company was successfully updated")
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        patch admin_company_path(company), params: { company: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /admin/companies/:id" do
    it "destroys the requested company" do
      company # create the company
      expect {
        delete admin_company_path(company)
      }.to change(Company, :count).by(-1)
    end

    it "redirects to the companies list" do
      delete admin_company_path(company)
      expect(response).to redirect_to(admin_companies_path)
    end

    it "sets success flash message" do
      delete admin_company_path(company)
      follow_redirect!
      expect(response.body).to include("was successfully deleted")
    end

    context "when company has stakeholders" do
      let!(:stakeholder) { create(:stakeholder, company: company) }

      it "shows error message and redirects to company" do
        delete admin_company_path(company)
        follow_redirect!
        expect(response.body).to include("Cannot delete company with existing stakeholders")
      end
    end
  end
end

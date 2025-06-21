require 'rails_helper'

RSpec.describe "Admin::Assessments", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/admin/assessments/show"
      expect(response).to have_http_status(:success)
    end
  end

end

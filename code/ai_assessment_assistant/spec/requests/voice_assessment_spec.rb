require 'rails_helper'

RSpec.describe "VoiceAssessments", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/voice_assessment/show"
      expect(response).to have_http_status(:success)
    end
  end

end

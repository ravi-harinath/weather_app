require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /show" do
    it "returns http success" do
     post weather_path, params: { postal_code: "12345" }
      expect(response).to have_http_status(:success)
    end
  end
end

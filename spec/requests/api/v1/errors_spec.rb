require "rails_helper"

describe "Routing Errors", type: :request do
  describe ".invalid_route" do
    context "making a GET request to an endpoint that does not exist" do
      it "returns an error" do
        get "/api/v1/invalid"

        expect(response.status).to eq 400
        expect(body["error"]).to eq(
          "the end point api/v1/invalid is not available"
        )
      end
    end

    context "making a POST request to an endpoint that does not exist" do
      it "returns an error" do
        post "/api/v1/invalid_route"

        expect(response.status).to eq 400
        expect(body["error"]).to eq(
          "the end point api/v1/invalid_route is not available"
        )
      end
    end
  end
end

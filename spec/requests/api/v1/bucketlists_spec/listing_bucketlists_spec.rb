require "rails_helper"

describe "BucketList GET /index", type: :request do 
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list, name: "Career plans") }
  let(:bucket1) { create(:bucket_list, name: "Family plans") }

  before do
    login(user)
  end

  context "as an authenticated user" do
    context "when bucketlist has been created by user" do
      it "returns all the bucketlists" do
        user.bucket_lists << bucket
        user.bucket_lists << bucket1

        get "/api/v1/bucketlists", {}, Authorization: user.token

        bucketlists = body.map { |m| m["name"] }

        expect(bucketlists).to match_array(["Career plans",
                                            "Family plans"])
        expect(response.status).to eq 200
      end
    end

    context "when no bucketlist has been created" do
      it "notifies the user correctly" do
        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 200

        expect(body["message"]).to eq MessageService.bucketlist_empty
      end
    end
  end

  context "as an unauthenticated user" do
    context "making a request without a token" do
      it "does not return the requested data" do
        get "/api/v1/bucketlists"

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end

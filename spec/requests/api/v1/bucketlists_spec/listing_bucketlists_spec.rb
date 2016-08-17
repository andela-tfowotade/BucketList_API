require "rails_helper"

describe "BucketList GET /index", type: :request do 
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list, name: "Career plans") }
  let(:bucket1) { create(:bucket_list, name: "Family plans") }

  before do
    login(user)
  end

  context "as an authenticated user" do
    context "when no bucketlist has been created" do
      it "notifies the user correctly" do
        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 200

        expect(body["message"]).to eq MessageService.bucketlist_empty
      end
    end

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

    context "with page and limit parameter" do 
      it "returns a paginated record of bucketlists" do
        3.times { create(:bucket_list, user: user) }

        get "/api/v1/bucketlists", { page: 1, limit: 2 },
          Authorization: user.token
        
        expect(response.status).to eq 200
        expect(body.count).to eq 2
      end
    end

    context "when paginate parameters are absent" do
      it "defaults to 20 bucketlists per page" do
        25.times { create(:bucket_list, user: user) }

        get "/api/v1/bucketlists", {},
          Authorization: user.token
        
        expect(response.status).to eq 200
        expect(body.count).to eq 20
      end
    end

    context "when page limit is greater than 100" do
      it "defaults to 100 bucketlists per page" do
        150.times { create(:bucket_list, user: user) }

        get "/api/v1/bucketlists", { page: 1, limit: 120 },
          Authorization: user.token
        
        expect(response.status).to eq 200
        expect(body.count).to eq 100
      end
    end

    context "with query parameter" do
      it "returns the filtered result of the bucketlist" do
        user.bucket_lists << bucket
        user.bucket_lists << bucket1

        get "/api/v1/bucketlists", { q: "family" }, Authorization: user.token

        expect(response.status).to eq 200
        expect(body[0]["name"]).to eq "Family plans"
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

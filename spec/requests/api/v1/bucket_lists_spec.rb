require "rails_helper"

describe "BucketLists", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list, name: "Buy a house") }
  let(:bucket1) { create(:bucket_list, name: "Buy a car") }

  describe "Get /welcome" do
    it "prompts user to sign up or login" do
      get "/api/v1/"

      expect(response.status).to eq 200
      expect(body["message"]).to eq("Welcome! Please sign up or login to continue.")
    end
  end

  before do
    login(user)
  end

  describe "GET /index" do
    context "when bucketlist has been created by user" do
      it "returns all the bucketlists" do
        user.bucket_lists << bucket
        user.bucket_lists << bucket1

        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 200

        bucketlists = body.map { |m| m["name"] }

        expect(bucketlists).to match_array(["Buy a house",
                                            "Buy a car"])
      end
    end

    context "when no bucketlist has been created" do
      it "notifies the user correctly" do
        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 200

        expect(body["message"]).to eq("No bucket list created yet.")
      end
    end
  end

  describe "POST /create" do
    context "with valid attributes" do
    end

    context "with invalid attributes" do
    end
  end

  describe "GET /show/<id>" do
    context "with <id> belonging to the user" do
    end

    context "with <id> not belonging to the user" do
    end
  end

  describe "PUT /update/<id>" do
    context "with valid attributes" do
    end

    context "with invalid attributes" do
    end
  end

  describe "DELETE /destroy/<id>" do
    context "with <id> belonging to the user" do
    end

    context "with <id> not belonging to the user" do
    end
  end
end

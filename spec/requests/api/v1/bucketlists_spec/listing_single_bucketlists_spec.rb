require "rails_helper"

describe "BucketList GET /show/<id>", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:bucket1) { create(:bucket_list) }

  before do
    login(user)
  end

  context "as an authenticated user" do
    context "with <id> belonging to the user" do
      it "returns the requested bucketlist" do
        user.bucket_lists << bucket

        get "/api/v1/bucketlists/#{bucket.id}", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body["id"]).to be_present
      end
    end

    context "with <id> not belonging to the user" do
      it "does not return a bucket list" do
        get "/api/v1/bucketlists/#{bucket.id}", {},
            Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq MessageService.unauthorized
      end
    end
  end

  context "as an unauthenticated user" do
    context "making a request without a token" do
      it "does not return the requested data" do
        get "/api/v1/bucketlists/#{bucket.id}"

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end
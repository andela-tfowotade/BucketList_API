require "rails_helper"

describe "Item GET /index", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list, name: "Travel goals") }
  let(:item) { create(:item, name: "Travel to Hawaii") }

  before do
    login(user)
    user.bucket_lists << bucket
  end

  context "as an authenticated user" do
    context "when item has been created by user" do
      it "returns all the items" do
        user.bucket_lists[0].items << item

        get "/api/v2/bucketlists/#{bucket.id}/items", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body[0]["name"]).to include("Travel to Hawaii")
      end
    end

    context "when no item has been created" do
      it "notifies the user of an empty bucket list items" do
        get "/api/v2/bucketlists/#{bucket.id}/items", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body["message"]).to eq MessageService.no_item
      end
    end

    context "making a request with an invalid bucket list id" do
      it "does not return the requested data" do
        get "/api/v2/bucketlists/0/items", {},
            Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq MessageService.unauthorized
      end
    end
  end

  context "as an unauthenticated user" do
    context "making a request without a token" do
      it "does not return the requested data" do
        get "/api/v2/bucketlists/#{bucket.id}/items"

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end

require "rails_helper"

describe "Item GET /show/<id>", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:item) { create(:item) }

  before do
    login(user)
    user.bucket_lists << bucket
  end

  context "as an authenticated user" do
    context "with a valid <id>" do
      it "returns the requested item" do
        user.bucket_lists[0].items << item

        get "/api/v2/bucketlists/#{bucket.id}/items/#{item.id}", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body["id"]).to be_present
      end
    end

    context "with invalid <id>" do
      it "does not return an item and displays the appropriate error" do
        get "/api/v2/bucketlists/#{bucket.id}/items/#{item.id}", {},
            Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq MessageService.unauthorized
      end
    end
  end

  context "as an unauthenticated user" do
    context "making a request without a token" do
      it "does not return the requested data" do
        get "/api/v2/bucketlists/#{bucket.id}/items/#{item.id}"

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end

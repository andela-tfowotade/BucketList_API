require "rails_helper"

describe "Item PUT /update/<id>", type: :request do 
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:item) { create(:item) }

  before do
    login(user)
    user.bucket_lists << bucket
  end

  context "as an authenticated user" do
    context "with valid attributes" do
      it "updates the item" do
        user.bucket_lists[0].items << item

        valid_item_attributes = attributes_for(:item)

        put "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}",
            valid_item_attributes, Authorization: user.token

        expect(response.status).to eq 200
        expect(body["id"]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not update the item" do
        user.bucket_lists[0].items << item

        invalid_item_attributes = attributes_for(:item, name: nil)

        put "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}",
            invalid_item_attributes, Authorization: user.token

        expect(response.status).to eq 422
        expect(body["name"]).to include("can't be blank")
      end
    end
  end

  context "as an unauthenticated user" do
    context "without a token" do
      it "does not update the item" do
        user.bucket_lists[0].items << item

        valid_item_attributes = attributes_for(:item)

        put "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}",
            valid_item_attributes

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end
require "rails_helper"

describe "Item POST /create", type: :request do 
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:item) { create(:item) }

  before do
    login(user)
    user.bucket_lists << bucket
  end

  context "as an authenticated user" do
    context "with valid attributes" do
      it "creates an item" do
        valid_item_attributes = attributes_for(:item)

        post "/api/v1/bucketlists/#{bucket.id}/items/",
             valid_item_attributes, Authorization: user.token

        expect(response.status).to eq 201
        expect(body["id"]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not create an item" do
        invalid_item_attributes = attributes_for(:item, name: nil)

        post "/api/v1/bucketlists/#{bucket.id}/items",
             invalid_item_attributes, Authorization: user.token

        expect(response.status).to eq 422
        expect(body["name"]).to eq ["can't be blank"]
      end
    end

    context "creating an item with an invalid bucket list id" do
      it "does not post the data" do
        valid_item_attributes = attributes_for(:item)

        post "/api/v1/bucketlists/0/items", valid_item_attributes,
             Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq MessageService.unauthorized
      end
    end
  end

  context "as an unauthenticated user" do
    context "without a token" do
      it "does not create the bucket list" do
        valid_item_attributes = attributes_for(:item)

        post "/api/v1/bucketlists/#{bucket.id}/items", valid_item_attributes

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end
require "rails_helper"

describe "Items", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:bucket) { FactoryGirl.create(:bucket_list, name: "Travel goals") }
  let(:item) { FactoryGirl.create(:item, name: "Travel to Hawaii") }

  before do
    login(user)
    user.bucket_lists << bucket
  end

  describe "GET /index" do
    context "when item has been created by user" do
      it "returns all the items" do
        user.bucket_lists[0].items << item

        get "/api/v1/bucketlists/#{bucket.id}/items", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body[0]["name"]).to include("Travel to Hawaii")
      end
    end

    context "when no item has been created" do
      it "notifies the user correctly" do
        get "/api/v1/bucketlists/#{bucket.id}/items", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body["message"]).to eq("No item created yet.")
      end
    end
  end

  describe "POST /create" do
    context "with valid attributes" do
      it "creates an item" do
        valid_item = FactoryGirl.build(:item)

        post "/api/v1/bucketlists/#{bucket.id}/items/", valid_item.attributes,
             Authorization: user.token

        expect(response.status).to eq 201
        expect(body["id"]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not create an item" do
        invalid_item = FactoryGirl.build(:item, name: nil)

        post "/api/v1/bucketlists/", invalid_item.attributes,
             Authorization: user.token

        expect(response.status).to eq 422
        expect(body["name"]).to include("can't be blank")
      end
    end
  end

  describe "GET /show/<id>" do
    context "with a valid <id>" do
      it "returns the requested item" do
        user.bucket_lists[0].items << item

        get "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}", {},
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body["id"]).to be_present
      end
    end

    context "with invalid <id>" do
      it "does not return an item and displays the appropriate error" do
        get "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}", {},
            Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq "Unauthorized access"
      end
    end
  end

  describe "PUT /update/<id>" do
    context "with valid attributes" do
      it "updates the item" do
        user.bucket_lists[0].items << item

        valid_item = FactoryGirl.build(:item)

        put "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}",
            valid_item.attributes, Authorization: user.token

        expect(response.status).to eq 200
        expect(body["id"]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not update the item" do
        user.bucket_lists[0].items << item

        invalid_item = FactoryGirl.build(:item, name: nil)

        put "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}",
            invalid_item.attributes, Authorization: user.token

        expect(response.status).to eq 422
        expect(body["name"]).to include("can't be blank")
      end
    end
  end

  describe "DELETE /destroy/<id>" do
    context "with valid <id>" do
      it "deletes the item" do
        user.bucket_lists[0].items << item

        delete "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}", {},
               Authorization: user.token

        expect(response.status).to eq 200
        expect(body["message"]).to eq "Item deleted successfully!"
      end
    end

    context "with <id> not belonging to the user" do
      it "does not deletes the item" do
        delete "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}", {},
               Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq "Unauthorized access"
      end
    end
  end
end

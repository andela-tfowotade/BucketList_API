require "rails_helper"

describe "Items", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list, name: "Travel goals") }
  let(:item) { create(:item, name: "Travel to Hawaii") }

  before do
    login(user)
    user.bucket_lists << bucket
  end

  describe "GET /index" do
    context "as an authenticated user" do
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
        it "notifies the user of an empty bucket list items" do
          get "/api/v1/bucketlists/#{bucket.id}/items", {},
              Authorization: user.token

          expect(response.status).to eq 200
          expect(body["message"]).to eq MessageService.no_item
        end
      end

      context "making a request with an invalid bucket list id" do
        it "does not return the requested data" do
          get "/api/v1/bucketlists/0/items", {},
              Authorization: user.token

          expect(response.status).to eq 404
          expect(body["error"]).to eq MessageService.unauthorized
        end
      end
    end

    context "as an unauthenticated user" do
      context "making a request without a token" do
        it "does not return the requested data" do
          get "/api/v1/bucketlists/#{bucket.id}/items"

          expect(response.status).to eq 401
          expect(body["error"]).to eq MessageService.unauthenticated
        end
      end
    end
  end

  describe "POST /create" do
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

  describe "GET /show/<id>" do
    context "as an authenticated user" do
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
          expect(body["error"]).to eq MessageService.unauthorized
        end
      end
    end

    context "as an unauthenticated user" do
      context "making a request without a token" do
        it "does not return the requested data" do
          get "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}"

          expect(response.status).to eq 401
          expect(body["error"]).to eq MessageService.unauthenticated
        end
      end
    end
  end

  describe "PUT /update/<id>" do
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

  describe "DELETE /destroy/<id>" do
    context "as an authenticated user" do
      context "with valid <id>" do
        it "deletes the item" do
          user.bucket_lists[0].items << item

          delete "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}", {},
                 Authorization: user.token

          expect(response.status).to eq 200
          expect(body["message"]).to eq MessageService.item_deleted
        end
      end

      context "with <id> not belonging to the user" do
        it "does not deletes the item" do
          delete "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}", {},
                 Authorization: user.token

          expect(response.status).to eq 404
          expect(body["error"]).to eq MessageService.unauthorized
        end
      end
    end

    context "as an unauthenticated user" do
      context "without a token" do
        it "does not delete the item" do
          delete "/api/v1/bucketlists/#{bucket.id}/items/#{item.id}"

          expect(response.status).to eq 401
          expect(body["error"]).to eq MessageService.unauthenticated
        end
      end
    end
  end
end

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
    end

    context "with invalid attributes" do
    end
  end

  describe "GET /show/<id>" do
    context "with a valid <id>" do
    end

    context "with invalid <id>" do
    end
  end

  describe "PUT /update/<id>" do
    context "with valid attributes" do
      
    end

    context "with invalid attributes" do
    end
  end

  describe "DELETE /destroy/<id>" do
    context "with valid <id>" do
    end

    context "with <id> not belonging to the user" do
    end
  end
end

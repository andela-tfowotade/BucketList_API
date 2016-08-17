require "rails_helper"

describe "BucketList POST /create", type: :request do 
  let(:user) { create(:user) }

  before do
    login(user)
  end

  context "as an authenticated user" do
    context "with valid attributes" do
      it "creates a bucket list" do
        valid_bucketlist_attributes = attributes_for(:bucket_list)

        post "/api/v1/bucketlists/", valid_bucketlist_attributes,
             Authorization: user.token

        expect(response.status).to eq 201
        expect(body["name"]).to be_present
        expect(body["created_by"]).to eq user.username
      end
    end

    context "with invalid attributes" do
      it "does not create a bucket list" do
        invalid_bucketlist_attributes = attributes_for(
                                                      :bucket_list,
                                                      name: nil
                                                      )

        post "/api/v1/bucketlists/", invalid_bucketlist_attributes,
             Authorization: user.token

        expect(response.status).to eq 422
        expect(body["name"]).to eq ["can't be blank"]
      end
    end
  end

  context "as an unauthenticated user" do
    context "creating a bucket list without a token" do
      it "does not post the data" do
        valid_bucketlist_attributes = attributes_for(:bucket_list)

        post "/api/v1/bucketlists/", valid_bucketlist_attributes

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end
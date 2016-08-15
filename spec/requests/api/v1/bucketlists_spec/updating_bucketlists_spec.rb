require "rails_helper"

describe "BucketList PUT /update/<id>", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:bucket1) { create(:bucket_list) }

  before do
    login(user)
  end

  context "as an authenticated user" do
    context "with valid attributes" do
      it "updates a bucket list" do
        user.bucket_lists << bucket
        valid_bucketlist_attributes = attributes_for(:bucket_list)

        put "/api/v1/bucketlists/#{bucket.id}", valid_bucketlist_attributes,
            Authorization: user.token

        expect(response.status).to eq 200
        expect(body["name"]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not update a bucket list" do
        user.bucket_lists << bucket
        invalid_bucketlist_attributes = attributes_for(
                                                      :bucket_list,
                                                       name: nil
                                                       )

        put "/api/v1/bucketlists/#{bucket.id}",
            invalid_bucketlist_attributes, Authorization: user.token

        expect(response.status).to eq 422
        expect(body["name"]).to include "can't be blank"
      end
    end
  end

  context "as an unauthenticated user" do
    context "updating a bucket list without a token" do
      it "does not update the data" do
        user.bucket_lists << bucket
        valid_bucketlist_attributes = attributes_for(:bucket_list)

        put "/api/v1/bucketlists/#{bucket.id}", valid_bucketlist_attributes

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end
require "rails_helper"

describe "BucketList DELETE /destroy/<id>", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:bucket1) { create(:bucket_list) }

  before do
    login(user)
  end

  context "as an authenticated user" do
    context "with <id> belonging to the user" do
      it "deletes the bucket list" do
        user.bucket_lists << bucket

        delete "/api/v1/bucketlists/#{bucket.id}", {},
               Authorization: user.token

        expect(response.status).to eq 200
        expect(body["message"]).to eq MessageService.bucketlist_deleted
      end
    end

    context "with <id> not belonging to the user" do
      it "does not deletes the bucket list" do
        delete "/api/v1/bucketlists/#{bucket.id}", {},
               Authorization: user.token

        expect(response.status).to eq 404
        expect(body["error"]).to eq MessageService.unauthorized
      end
    end
  end

  context "as an unauthenticated user" do
    context "deleting a bucket list without a token" do
      it "does not delete the bucketlist" do
        delete "/api/v1/bucketlists/#{bucket.id}"

        expect(response.status).to eq 401
        expect(body["error"]).to eq MessageService.unauthenticated
      end
    end
  end
end
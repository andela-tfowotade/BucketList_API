require "rails_helper"

describe "Item DELETE /destroy/<id>", type: :request do 
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list) }
  let(:item) { create(:item) }

  before do
    login(user)
    user.bucket_lists << bucket
  end

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
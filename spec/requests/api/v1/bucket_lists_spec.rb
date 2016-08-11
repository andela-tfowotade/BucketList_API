require "rails_helper"

describe "BucketLists", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket_list, name: "Career plans") }
  let(:bucket1) { create(:bucket_list, name: "Family plans") }

  describe "Get /welcome" do
    it "prompts user to sign up or login" do
      get "/api/v1/"

      expect(response.status).to eq 200
      expect(body["message"]).to eq MessageService.welcome
    end
  end

  before do
    login(user)
  end

  describe "GET /index" do
    context "as an authenticated user" do
      context "when bucketlist has been created by user" do
        it "returns all the bucketlists" do
          user.bucket_lists << bucket
          user.bucket_lists << bucket1

          get "/api/v1/bucketlists", {}, Authorization: user.token

          expect(response.status).to eq 200

          bucketlists = body.map { |m| m["name"] }

          expect(bucketlists).to match_array(["Career plans",
                                              "Family plans"])
        end
      end

      context "when no bucketlist has been created" do
        it "notifies the user correctly" do
          get "/api/v1/bucketlists", {}, Authorization: user.token

          expect(response.status).to eq 200

          expect(body["message"]).to eq MessageService.bucketlist_empty
        end
      end
    end

    context "as an unauthenticated user" do
      context "making a request without a token" do
        it "does not return the requested data" do
          get "/api/v1/bucketlists"

          expect(response.status).to eq 401
          expect(body["error"]).to eq MessageService.unauthenticated
        end
      end
    end
  end

  describe "POST /create" do
    context "as an authenticated user" do
      context "with valid attributes" do
        it "creates a bucket list" do
          valid_bucketlist_attributes = attributes_for(:bucket_list)

          post "/api/v1/bucketlists/", valid_bucketlist_attributes,
               Authorization: user.token

          expect(response.status).to eq 201
          expect(body["name"]).to be_present
        end
      end

      context "with invalid attributes" do
        it "does not create a bucket list" do
          invalid_bucketlist_attributes = attributes_for(:bucket_list, name: nil)

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

  describe "GET /show/<id>" do
    context "as an authenticated user" do
      context "with <id> belonging to the user" do
        it "returns the requested bucketlist" do
          user.bucket_lists << bucket

          get "/api/v1/bucketlists/#{bucket.id}", {},
              Authorization: user.token

          expect(response.status).to eq 200
          expect(body["id"]).to be_present
        end
      end

      context "with <id> not belonging to the user" do
        it "does not return a bucket list and displays the appropriate error" do
          get "/api/v1/bucketlists/#{bucket.id}", {},
              Authorization: user.token

          expect(response.status).to eq 404
          expect(body["error"]).to eq MessageService.unauthorized
        end
      end
    end

    context "as an unauthenticated user" do
      context "making a request without a token" do
        it "does not return the requested data" do
          get "/api/v1/bucketlists/#{bucket.id}"

          expect(response.status).to eq 401
          expect(body["error"]).to eq MessageService.unauthenticated
        end
      end
    end
  end

  describe "PUT /update/<id>" do
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
          invalid_bucketlist_attributes = attributes_for(:bucket_list, name: nil)

          put "/api/v1/bucketlists/#{bucket.id}", invalid_bucketlist_attributes,
              Authorization: user.token

          expect(response.status).to eq 422
          expect(body["name"]).to include "can't be blank"
        end
      end
    end

    context "as an unauthenticated user" do
      context "updating a bucket list without a token" do
        it "does not put the data" do
          user.bucket_lists << bucket
          valid_bucketlist_attributes = attributes_for(:bucket_list)

          put "/api/v1/bucketlists/#{bucket.id}", valid_bucketlist_attributes

          expect(response.status).to eq 401
          expect(body["error"]).to eq MessageService.unauthenticated
        end
      end
    end
  end

  describe "DELETE /destroy/<id>" do
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
end

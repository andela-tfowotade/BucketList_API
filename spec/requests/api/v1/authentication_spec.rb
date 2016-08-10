require "rails_helper"

describe "Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST /auth/create_user" do
    context "with valid details" do
      it "creates a new user" do
        valid_user_attributes = attributes_for(:user)

        post "/api/v1/auth/create_user", valid_user_attributes

        expect(response.status).to eq 201
        expect(body["email"]).to be_present
      end
    end

    context "with invalid details" do
      it "does not create a new user" do
        invalid_user = build(:user, password: nil)

        post "/api/v1/auth/create_user", invalid_user.attributes

        expect(response.status).to eq 422
        expect(body["password"]).to eq ["can't be blank"]
      end
    end
  end

  describe "POST /auth/login" do
    context "logging in with valid user" do
      it "displays the user's token" do
        post "/api/v1/auth/login", email: user.email, password: "password"

        expect(response.status).to eq 200
        expect(body["auth_token"]).to be_present
      end
    end

    context "logging in with an invalid user" do
      it "displays the user's token" do
        post "/api/v1/auth/login", email: user.email, password: "invalid_password"

        expect(response.status).to eq 401
        expect(body["error"]).to eq "Invalid Username/Password"
      end
    end
  end

  describe "GET /auth/logout" do
    context "when logged in" do
      it "logs the user out" do
        login(user)

        get "/api/v1/auth/logout", {}, Authorization: user.token

        expect(response.status).to eq 200
        expect(body["message"]).to eq "Log out successful!"
      end
    end

    context "when making a request with token after logout" do
      it "prompts the user to sign in" do
        login(user)
        get "/api/v1/auth/logout", {}, Authorization: user.token

        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 422
        expect(body["error"]).to eq "You're logged out! Please login to continue."
      end
    end
  end
end

require "rails_helper"

describe "Authentication", type: :request do
  let(:user) { FactoryGirl.create(:user) }

  describe "POST /login" do
    context "when making a request without a token" do
      it "does not submit request" do
        get "/api/v1/bucketlists"

        expect(response.status).to eq 401
        expect(body["error"]).to eq "Not Authenticated"
      end
    end

    context "when making a request with a token" do
      it "submits the request" do
        login(user)

        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 200
      end
    end

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

  describe "GET /logout" do
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

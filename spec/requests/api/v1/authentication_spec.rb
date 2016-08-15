require "rails_helper"

describe "Authentication", type: :request do
  let(:user) { create(:user) }

  describe "GET /welcome" do
    it "prompts user to sign up or login" do
      get "/api/v1/"

      expect(response.status).to eq 200
      expect(body["message"]).to eq MessageService.welcome
    end
  end

  describe "POST /auth/create_user" do
    context "with valid details" do
      it "creates a new user" do
        valid_user_attributes = attributes_for(:user)

        post "/api/v1/auth/create_user", valid_user_attributes

        expect(response.status).to eq 201
        expect(body["token"]).to be_present
      end
    end

    context "with invalid details" do
      it "does not create a new user" do
        invalid_user_attributes = attributes_for(:user, password: nil)

        post "/api/v1/auth/create_user", invalid_user_attributes

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

    context "logging in with an invalid password" do
      it "does not log user in" do
        post "/api/v1/auth/login", email: user.email,
                                   password: "invalid_password"

        expect(response.status).to eq 422
        expect(body["error"]).to eq MessageService.invalid_attributes
      end
    end

    context "logging in with an invalid email" do
      it "does not log user in" do
        post "/api/v1/auth/login",
             email: "invalid_email@example.com",
             password: "password"

        expect(response.status).to eq 422
        expect(body["error"]).to eq MessageService.user_not_found
      end
    end
  end

  describe "GET /auth/logout" do
    before do
      login(user)
      get "/api/v1/auth/logout", {}, Authorization: user.token
    end

    context "when logged in" do
      it "logs the user out" do
        expect(response.status).to eq 200
        expect(body["message"]).to eq MessageService.logout_success
      end
    end

    context "making a request with token after log out" do
      it "prompts the user to sign in" do
        get "/api/v1/bucketlists", {}, Authorization: user.token

        expect(response.status).to eq 422
        expect(body["error"]).to eq MessageService.logged_out
      end
    end
  end
end

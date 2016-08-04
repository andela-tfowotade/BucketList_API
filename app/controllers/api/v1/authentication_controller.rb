class Api::V1::AuthenticationController < ApplicationController
  before_action :authenticate_request!, only: :logout
  before_action :check_user, only: :login

  def login
    if @user.valid_password?(params[:password])
      @user.update(token: payload(@user)[:auth_token])

      render json: payload(@user)
    else
      render json: { error: "Invalid Username/Password" },
             status: :unauthorized
    end
  end

  def logout
    current_user.update(token: nil)
    render json: { message: "Log out successful!" }, status: 200
  end

  private

  def check_user
    @user = User.find_for_database_authentication(email: params[:email])

    unless @user
      render json: "User not found! Sign up to continue", status: :unprocessable_entity
    end
  end

  def payload(user)
    return nil unless user && user.id
    {
      auth_token: JsonWebToken.encode(user_id: user.id),
      user: { id: user.id, email: user.email }
    }
  end
end

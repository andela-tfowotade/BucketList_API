class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { error: "Not Authenticated" }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])

    unless @current_user.token
      render json: { error: "You're logged out! Please login to continue." },
      status: :unprocessable_entity
    end
  end

  private
  
  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end

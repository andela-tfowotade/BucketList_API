class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def http_token
    @http_token ||= if request.headers["Authorization"].present?
                      request.headers["Authorization"].split(" ").last
    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { error: MessageService.unauthenticated },
             status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])

    unless @current_user.token
      render json: { error: MessageService.logged_out },
             status: :unprocessable_entity
    end
  end
end

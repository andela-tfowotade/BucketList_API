module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authenticate_request!, only: :logout
      before_action :check_user, only: :login

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def login
        if @user.valid_password?(params[:password])
          @user.update(token: payload(@user)[:auth_token])

          render json: payload(@user)
        else
          render json: { error: MessageService.invalid_attributes },
                 status: :unprocessable_entity
        end
      end

      def logout
        current_user.update(token: nil)
        render json: { message: MessageService.logout_success }, status: 200
      end

      private

      def check_user
        @user = User.find_for_database_authentication(email: params[:email])

        unless @user
          render json: { error: MessageService.user_not_found },
                 status: :unprocessable_entity
        end
      end

      def payload(user)
        return nil unless user && user.id
        {
          auth_token: JsonWebToken.encode(user_id: user.id),
          user: { id: user.id, email: user.email }
        }
      end

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end

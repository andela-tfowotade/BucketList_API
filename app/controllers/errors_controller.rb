class ErrorsController < ApplicationController
  def invalid_route
    render json: { error: "the end point #{params[:url]} is not available" },
           status: :bad_request
  end
end

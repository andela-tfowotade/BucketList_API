class Api::V1::BucketListsController < ApplicationController
  before_action :authenticate_request!, except: :welcome

  def welcome
    render json: { message: "Welcome! Please sign up or login to continue." },
           status: 200
  end

  def index
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end
end

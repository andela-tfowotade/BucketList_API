class Api::V1::BucketListsController < ApplicationController
  before_action :authenticate_request!, except: :welcome

  def welcome
    render json: { message: "Welcome! Please sign up or login to continue." },
           status: 200
  end

  def index
    bucket_lists = current_user.bucket_lists

    if bucket_lists.empty?
      render json: { message: "No bucket list created yet." }, status: 200
    else
      render json: bucket_lists, status: 200
    end
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

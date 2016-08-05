class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_bucket_list, only: [:set_item, :index, :create, :show,
                                         :update, :destroy]
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    items = @bucket_list.items

    if items.empty?
      render json: { message: "No item created yet." }, status: 200
    else
      render json: items, status: 200
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

  private

  def set_bucket_list
    @bucket_list = current_user.bucket_lists.find(params[:bucketlist_id])

    unless @bucket_list
      render json: { error: "Unauthorized access" }, status: 404
    end
  end
end

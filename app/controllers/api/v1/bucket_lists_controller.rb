class Api::V1::BucketListsController < ApplicationController
  before_action :authenticate_request!, except: :welcome
  before_action :set_bucketlist, only: [:show, :update, :destroy]

  def welcome
    render json: { message: "Welcome! Please Sign up or login to continue." },
           status: 200
  end

  def index
    @bucket_lists = current_user.bucket_lists

    if @bucket_lists.empty?
      render json: { message: "No bucket list created yet." }, status: 200
    else
      render json: @bucket_lists.paginate_and_search(params), status: 200
    end
  end

  def create
    @bucket_list = current_user.bucket_lists.new(bucket_list_params)

    if @bucket_list.save
      render json: @bucket_list, status: :created
    else
      render json: @bucket_list.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @bucket_list
  end

  def update
    if @bucket_list.update(bucket_list_params)
      render json: @bucket_list, status: 200
    else
      render json: @bucket_list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @bucket_list.destroy
    render json: { message: "Bucket list deleted successfully!" }, status: 200
  end

  private

  def set_bucketlist
    @bucket_list = current_user.bucket_lists.find_by(id: params[:id])

    unless @bucket_list
      render json: { error: "Unauthorized access" }, status: 404
    end
  end

  def bucket_list_params
    params.permit(:name, :created_by)
  end
end

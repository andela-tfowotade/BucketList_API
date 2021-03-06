module Api
  module V2
    class ItemsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_bucket_list
      before_action :set_item, only: [:show, :update, :destroy]

      def index
        items = @bucket_list.items

        if items.empty?
          render json: { message: MessageService.no_item }, status: :ok
        else
          render json: items, status: :ok
        end
      end

      def create
        @item = @bucket_list.items.new(item_params)

        if @item.save
          render json: @item, status: :created
        else
          render json: @item.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @item, status: :ok
      end

      def update
        if @item.update(item_params)
          render json: @item, status: :ok
        else
          render json: @item.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @item.destroy
        render json: { message: MessageService.item_deleted }, status: :ok
      end

      private

      def set_bucket_list
        @bucket_list = current_user.bucket_lists.
                       find_by(id: params[:bucketlist_id])

        unless @bucket_list
          render json: { error: MessageService.unauthorized }, status: 404
        end
      end

      def set_item
        @item = @bucket_list.items.find_by(id: params[:id])

        unless @item
          render json: { error: MessageService.unauthorized }, status: 404
        end
      end

      def item_params
        params.permit(:name, :target_completion_date)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      before_action :find_item, only: %i[show update destroy]

      def index
        if params[:merchant_id]
          if Merchant.exists?(params[:merchant_id])
            render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
          else
            render json: ErrorSerializer.no_found_merchant(params[:merchant_id]), status: :not_found
          end
        else
          render json: ItemSerializer.new(Item.all)
        end
      end

      def show
        render json: ItemSerializer.new(@item)
      end

      def create
        render json: ItemSerializer.new(Item.create(item_params)), status: :created
      end

      def update
        Merchant.find(params[:item][:merchant_id]) if params[:item][:merchant_id]
        render json: ItemSerializer.new(Item.update(@item.id, item_params))
      end

      def destroy
        Item.destroy(@item.id)
        Invoice.all.map(&:destroy_empty)
        head :no_content
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def find_item
        @item = Item.find(params[:id])
      end
    end
  end
end

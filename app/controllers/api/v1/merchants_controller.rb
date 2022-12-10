# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        if params[:item_id]
          item = Item.find(params[:item_id])
          render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
        else
          render json: MerchantSerializer.new(Merchant.find(params[:id]))
        end
      end
    end
  end
end

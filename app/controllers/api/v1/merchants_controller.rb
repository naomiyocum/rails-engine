class Api::V1::MerchantsController < ApplicationController
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

  def find
    if params[:name]
      render json: MerchantSerializer.new(Merchant.find_one_name(params[:name]))
    end
  end
end
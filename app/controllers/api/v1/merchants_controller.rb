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
    if find_one_result == nil
      render json: ErrorSerializer.new(params[:name]).no_found_merchant
    else
      render json: MerchantSerializer.new(find_one_result)
    end
  end

private
  def find_one_result
    Merchant.find_one_name(params[:name])
  end
end
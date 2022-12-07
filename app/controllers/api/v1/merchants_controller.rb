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
    if find_result == []
      render json: {"data" => {}}
    else
      render json: MerchantSerializer.new(find_result.first)
    end
  end

  def find_all
    render json: MerchantSerializer.new(find_result)
  end

private
  def find_result
    Merchant.find_all(params[:name])
  end
end
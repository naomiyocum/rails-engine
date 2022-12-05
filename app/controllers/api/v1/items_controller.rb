class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    else
      render json: ItemSerializer.new(Item.all)
    end
  end
end
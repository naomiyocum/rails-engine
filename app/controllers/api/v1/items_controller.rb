class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      if Merchant.exists?(params[:merchant_id])
        render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
      else
        Merchant.find(params[:merchant_id])
      end
    else
      render json: ItemSerializer.new(Item.all)
    end
  end
  
  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update
    if params[:item][:merchant_id]
      merchant = Merchant.find(params[:item][:merchant_id])
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    end
  end

  def destroy
    item = ItemSerializer.new(Item.find(params[:id]))
    Item.destroy(item)
    head :no_content
  end

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
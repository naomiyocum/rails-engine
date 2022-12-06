class Api::V1::ItemsController < ApplicationController
  before_action :find_item, only: %i[show update destroy]
  
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
    Invoice.all.map {|invoice| invoice.destroy_empty}
    head :no_content
  end
  
  def find_all
    if params[:name]
      render json: ItemSerializer.new(Item.find_all_name(params[:name]))
    end
  end

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def find_item
    @item = Item.find(params[:id])
  end
end
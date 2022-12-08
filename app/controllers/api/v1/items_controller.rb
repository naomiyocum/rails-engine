class Api::V1::ItemsController < ApplicationController
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
    Invoice.all.map {|invoice| invoice.destroy_empty}
    head :no_content
  end

  def find
    raise ActionController::ParameterMissing.new(params) if CallSearch.search_item(params)

    if params[:name]
      render json: ItemSerializer.new(Item.find_all_name(params[:name]).first)
    elsif params[:min_price] && params[:max_price]
      render json: ItemSerializer.new(Item.find_all_range(params[:min_price], params[:max_price]).first)
    elsif params[:min_price]
      render json: ItemSerializer.new(Item.find_all_min(params[:min_price]).first)
    elsif params[:max_price]
      render json: ItemSerializer.new(Item.find_all_max(params[:max_price]).last)
    end
  end
  
  def find_all
    raise ActionController::ParameterMissing.new(params) if CallSearch.search_item(params)

    if params[:name]
      render json: ItemSerializer.new(Item.find_all_name(params[:name]))
    elsif params[:min_price] && params[:max_price]
      render json: ItemSerializer.new(Item.find_all_range(params[:min_price], params[:max_price]))
    elsif params[:min_price]
      render json: ItemSerializer.new(Item.find_all_min(params[:min_price]))
    elsif params[:max_price]
      render json: ItemSerializer.new(Item.find_all_max(params[:max_price]))
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
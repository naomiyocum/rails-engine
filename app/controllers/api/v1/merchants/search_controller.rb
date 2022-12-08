class Api::V1::Merchants::SearchController < ApplicationController
  def index
    raise ActionController::ParameterMissing.new(params) if CallSearch.search_merchant(params)

    render json: MerchantSerializer.new(find_result)
  end

  def show
    raise ActionController::ParameterMissing.new(params) if CallSearch.search_merchant(params)

    if find_result == []
      render json: {"data" => {}}
    else
      render json: MerchantSerializer.new(find_result.first)
    end
  end

private
  def find_result
    Merchant.find_all(params[:name])
  end
end
class CallSearch < ApplicationController
  def self.search_item(params)
    if params[:name] && params[:min_price]
      true
    elsif params[:name] && params[:max_price]
      true
    elsif params[:min_price] && params[:min_price].to_f < 0
      true
    elsif params[:max_price] && params[:max_price].to_f < 0
      true
    elsif params[:name] == ""
      true
    elsif params[:max_price] == ""
      true
    elsif params[:min_price] == ""
      true
    elsif params[:min_price] && params[:max_price] && params[:min_price].to_f > params[:max_price].to_f
      true
    elsif (params.has_key?(:name) || params.has_key?(:min_price) || params.has_key?(:max_price)) == false
      true
    end
  end

  def self.search_merchant(params)
    if params[:name] == ""
      true
    elsif (params.has_key?(:name)) == false
      true
    end
  end
end
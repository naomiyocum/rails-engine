class CallSearch < ApplicationController
  def self.search(params)
    if params[:name] && params[:min_price]
      true
    elsif params[:name] && params[:max_price]
      true
    elsif params[:min_price] && params[:min_price].to_f < 0
      true
    elsif params[:max_price] && params[:max_price].to_f < 0
      true
    end
  end
end
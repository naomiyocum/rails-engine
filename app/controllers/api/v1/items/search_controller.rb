# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          if CallSearch.search_item(params)
            render json: ErrorSerializer.invalid_params, status: :bad_request
          elsif params[:name]
            render json: ItemSerializer.new(Item.find_all_name(params[:name]))
          elsif params[:min_price] && params[:max_price]
            render json: ItemSerializer.new(Item.find_all_range(params[:min_price], params[:max_price]))
          elsif params[:min_price]
            render json: ItemSerializer.new(Item.find_all_min(params[:min_price]))
          elsif params[:max_price]
            render json: ItemSerializer.new(Item.find_all_max(params[:max_price]))
          end
        end

        def show
          if CallSearch.search_item(params)
            render json: ErrorSerializer.invalid_params, status: :bad_request
          elsif params[:name]
            render json: ItemSerializer.new(Item.find_all_name(params[:name]).first)
          elsif params[:min_price] && params[:max_price]
            render json: ItemSerializer.new(Item.find_all_range(params[:min_price], params[:max_price]).first)
          elsif params[:min_price]
            render json: ItemSerializer.new(Item.find_all_min(params[:min_price]).first)
          elsif params[:max_price]
            render json: ItemSerializer.new(Item.find_all_max(params[:max_price]).last)
          end
        end
      end
    end
  end
end

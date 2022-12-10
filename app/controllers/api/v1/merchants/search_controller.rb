# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          if CallSearch.search_merchant(params)
            render json: ErrorSerializer.invalid_params, status: :bad_request
          else
            render json: MerchantSerializer.new(find_result)
          end
        end

        def show
          if CallSearch.search_merchant(params)
            render json: ErrorSerializer.invalid_params, status: :bad_request
          elsif find_result == []
            render json: { 'data' => {} }
          else
            render json: MerchantSerializer.new(find_result.first)
          end
        end

        private

        def find_result
          Merchant.find_all(params[:name])
        end
      end
    end
  end
end

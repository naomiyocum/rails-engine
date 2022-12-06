class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

private
  def record_not_found
    render file: "#{Rails.root}/public/404", layout: true, status: :not_found
  end
end

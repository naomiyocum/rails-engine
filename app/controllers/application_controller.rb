class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :invalid_params

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def invalid_params(exception)
    render json: { errors: exception.message }, status: :bad_request
  end
end

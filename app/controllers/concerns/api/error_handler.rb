module Api
  # General API concern to gracefully handle request errors.
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActionController::ParameterMissing, with: :bad_request
      rescue_from WeatherApi::FetchError, with: :internal_server_error
    end

    private

    def bad_request
      render json: { message: 'One or more parameters missing' }, status: :bad_request
    end

    def internal_server_error
      render(json: { message: 'Something went wrong' }, status: :internal_server_error)
    end
  end
end

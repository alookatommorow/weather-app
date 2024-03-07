module Api
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActionController::ParameterMissing, with: :bad_request
    end

    private

    def bad_request
      render json: { message: 'One or more parameters missing' }, status: :bad_request
    end
  end
end

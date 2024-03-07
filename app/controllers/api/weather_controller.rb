module Api
  class WeatherController < ApplicationController
    CACHE_PREFIX = 'weather_api:forecast'.freeze

    rescue_from ActionController::ParameterMissing, with: :bad_request

    def forecast
      json = cached_api_forecast.merge(cache_hit: @cache_hit.present?)
      render json:
    end

    private

    def bad_request
      render json: { message: 'One or more parameters missing' }, status: :bad_request
    end

    def query_params
      params.require(:query)
    end

    def api_forecast
      WeatherApi::Forecast.new(query: query_params).fetch
    end

    def cached_api_forecast
      return api_forecast if params[:zip_code].blank?

      @cache_hit = true

      Rails.cache.fetch("#{CACHE_PREFIX}:#{params[:zip_code]}", expires_in: 30.minutes) do
        @cache_hit = false
        api_forecast
      end
    end
  end
end

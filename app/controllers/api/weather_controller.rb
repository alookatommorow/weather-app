module Api
  class WeatherController < ApplicationController
    FORECAST_CACHE_PREFIX = 'weather_api:forecast'.freeze
    include ErrorHandler

    # @return [Hash]
    #   forecast JSON if successful api call or cache read
    #   [boolean] cache_hit
    #     indicates a successful cache read
    # @return [Hash]
    #   error message JSON if failed api call
    #   Ex: { 'message' => 'Something went wrong' }
    # @see WeatherApi::Forecast#fetch
    def forecast
      json = cached_api_forecast.merge(cache_hit: @cache_hit.present?)
      render json:
    end

    private

    def query_params
      params.require(:query)
    end

    def api_forecast
      WeatherApi::Forecast.new(query: query_params).fetch!
    end

    def forecast_cache_key
      return if params[:zip_code].blank?

      "#{FORECAST_CACHE_PREFIX}:#{params[:zip_code]}"
    end

    # caches forecast JSON by zip code for 30 minutes
    def cached_api_forecast
      return api_forecast if forecast_cache_key.blank?

      @cache_hit = true
      Rails.cache.fetch(forecast_cache_key, expires_in: 30.minutes) do
        @cache_hit = false
        api_forecast
      end
    end
  end
end

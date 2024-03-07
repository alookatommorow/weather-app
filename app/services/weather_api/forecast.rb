module WeatherApi
  class Forecast < Base
    PATH = '/forecast.json'.freeze
    FORECAST_DAYS = 3

    def fetch!
      response = self.class.get(PATH, options)

      return response.parsed_response if response.success?

      raise ::WeatherApi::FetchError, 'Unable to fetch weather'
    end

    private

    def options
      super.deep_merge(query: { days: FORECAST_DAYS })
    end
  end
end

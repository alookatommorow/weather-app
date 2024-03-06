module WeatherApi
  class Forecast < Base
    PATH = '/forecast.json'.freeze
    FORECAST_DAYS = 3

    def fetch
      self.class.get(PATH, options).parsed_response
    end

    private

    def options
      super.deep_merge(query: { days: FORECAST_DAYS })
    end
  end
end

module WeatherApi
  # Extends base class to fetch data from forecast API
  # @see API docs at https://www.weatherapi.com/docs/#apis-forecast
  class Forecast < Base
    PATH = '/forecast.json'.freeze
    FORECAST_DAYS = 3

    # @return [Hash]
    #   JSON response from forecast API if call is successful
    #   Ex:
    #     {
    #       'forecast' => {
    #         'forecastday' => [{ 'day' => { 'maxtemp_f' => 57.7 } }]
    #       }
    #     }
    # @raise [WeatherApi::FetchError] if api call fails
    # @see https://www.weatherapi.com/docs/#apis-forecast for full response structure
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

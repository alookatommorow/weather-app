module WeatherApi
  # Base class for making requests to 'http://api.weatherapi.com/v1'
  # Can be extended to fetch data from different API endpoints
  # @see API docs at https://www.weatherapi.com/docs/
  class Base
    include HTTParty
    base_uri 'http://api.weatherapi.com/v1'

    # @param [String] query
    #   The query to pass to the Weather API,
    #   Ex: '28.123,-123.677'
    # @see https://www.weatherapi.com/docs/#intro-request-param for possible query values
    def initialize(query:)
      @query = query
    end

    private

    attr_reader :query

    def options
      {
        query: {
          key: ENV.fetch('WEATHER_KEY'),
          q: query
        }
      }
    end
  end
end

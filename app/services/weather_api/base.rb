module WeatherApi
  class FetchError < StandardError; end

  class Base
    include HTTParty
    base_uri 'http://api.weatherapi.com/v1'

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

class RootController < ApplicationController
  def show
    res = WeatherApi::Forecast.new(query: 94619).fetch
    binding.pry
  end
end

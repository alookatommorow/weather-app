require 'rails_helper'

RSpec.describe '/api/weather' do
  describe 'GET #forecast' do
    it 'returns weather json' do
      forecast_mock = instance_double(WeatherApi::Forecast)
      query = '34.66,-197.11'
      json_mock = {
        'forecast' => {
          'forecastday' => [{ 'day' => { 'maxtemp_f' => 57.7 } }]
        }
      }
      expected = json_mock.merge('cache_hit' => false)

      allow(WeatherApi::Forecast).to receive(:new).with(query:).and_return(forecast_mock)
      allow(forecast_mock).to receive(:fetch).and_return(json_mock)

      get forecast_api_weather_path, params: { query: }

      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq expected
    end

    context 'when query param is missing' do
      it 'returns 400 with error message' do
        get forecast_api_weather_path

        parsed_response = JSON.parse(response.body)

        expect(parsed_response['message']).to eq 'One or more parameters missing'
        expect(response).to have_http_status :bad_request
      end
    end
  end
end

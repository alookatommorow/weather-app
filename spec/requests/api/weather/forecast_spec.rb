require 'rails_helper'

RSpec.describe '/api/weather' do
  describe 'GET #forecast' do
    let(:query) { '34.66,-197.11' }
    let(:forecast_mock) { instance_double(WeatherApi::Forecast) }
    let(:json_mock) do
      {
        'forecast' => {
          'forecastday' => [{ 'day' => { 'maxtemp_f' => 57.7 } }]
        }
      }
    end

    before do
      allow(WeatherApi::Forecast).to receive(:new).with(query:).and_return(forecast_mock)
      allow(forecast_mock).to receive(:fetch!).and_return(json_mock)
    end

    it 'returns weather json' do
      expected = json_mock.merge('cache_hit' => false)

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

    context 'when fetch fails' do
      it 'returns 500 with error message' do
        error_message = 'Something went wrong'
        allow(forecast_mock).to receive(:fetch!).and_raise(WeatherApi::FetchError, error_message)

        get forecast_api_weather_path, params: { query: }

        parsed_response = JSON.parse(response.body)

        expect(parsed_response['message']).to eq error_message
        expect(response).to have_http_status :internal_server_error
      end
    end

    context 'with cache' do
      let(:zip_code) { '94619' }
      let(:cache_key) { "#{Api::WeatherController::FORECAST_CACHE_PREFIX}:#{zip_code}" }
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:subject) do
        get forecast_api_weather_path, params: { query:, zip_code: }
      end

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
      end

      after(:each) do
        Rails.cache.clear
      end

      context 'with cache miss' do
        it 'writes forecast json to the cache' do
          subject

          expect(Rails.cache.read(cache_key)).to eq json_mock
          expect(forecast_mock).to have_received(:fetch!)
        end
      end

      context 'with cache hit' do
        before do
          Rails.cache.write(cache_key, json_mock, expires_in: 30.minutes)
        end

        it 'reads forecast json from the cache' do
          subject

          expect(forecast_mock).not_to have_received(:fetch!)
        end

        it 'returns json with cache_hit: true' do
          expected = json_mock.merge('cache_hit' => true)

          subject

          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to eq expected
        end
      end
    end
  end
end

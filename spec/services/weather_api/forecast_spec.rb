require 'rails_helper'

describe WeatherApi::Forecast do
  describe '#forecast' do
    let(:query) { 94619 }
    let(:subject) { described_class.new(query:).fetch }

    it 'returns parsed response from weather api' do
      response_mock = instance_double(HTTParty::Response)
      json_mock = {
        'location' => { 'name' => 'Oakland' },
        'forecast' => {
          'forecastday' => [
            {
              'date' => '2024-03-06',
              'day' => { 'maxtemp_f' => 57.7 }
            }
          ]
        }
      }

      allow(described_class).to receive(:get).and_return(response_mock)
      allow(response_mock).to receive(:parsed_response).and_return(json_mock)

      subject

      expect(described_class).to have_received(:get).with(
        described_class::PATH, {
          query: {
            key: ENV['WEATHER_KEY'],
            q: query,
            days: described_class::FORECAST_DAYS
          }
        }
      )
      expect(subject).to eq json_mock
    end
  end
end

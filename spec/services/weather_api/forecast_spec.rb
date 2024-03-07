require 'rails_helper'

RSpec.describe WeatherApi::Forecast do
  describe '#forecast' do
    let(:query) { '33.1872,-117.564' }
    let(:response_mock) { instance_double(HTTParty::Response) }
    let(:json_mock) do
      {
        'forecast' => {
          'forecastday' => [{ 'day' => { 'maxtemp_f' => 57.7 } }]
        }
      }
    end

    let(:subject) { described_class.new(query:).fetch! }

    before do
      allow(described_class).to receive(:get).and_return(response_mock)
      allow(response_mock).to receive(:parsed_response).and_return(json_mock)
    end

    it 'returns parsed json response from weather api' do
      allow(response_mock).to receive(:success?).and_return true

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

    context 'with api failure' do
      it 'returns parsed json response from weather api' do
        allow(response_mock).to receive(:success?).and_return false

        expect { subject }.to raise_error WeatherApi::FetchError
      end
    end
  end
end

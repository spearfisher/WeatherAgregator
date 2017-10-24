require 'rails_helper'

RSpec.describe ThirdPartyApi::OpenWeatherMap do
  subject { described_class.new(23, 54) }

  it 'validates constants' do
    expect(described_class::PROVIDER).to eq('openweathermap')
    expect { described_class::PROVIDER << 'some_string' }.to raise_error(RuntimeError)

    expect(described_class::BASE_URL).to eq('http://api.openweathermap.org/data/2.5/weather')
    expect { described_class::BASE_URL << 'some_string' }.to raise_error(RuntimeError)

    expect(described_class::QUERY_PARAMS).to eq('units=metric')
    expect { described_class::QUERY_PARAMS << 'some_string' }.to raise_error(RuntimeError)

    expect(described_class::API_KEY).to eq('KeyForOpenWeatherMap')
    expect { described_class::API_KEY << 'some_string' }.to raise_error(RuntimeError)
  end

  it 'builds correct API url' do
    url = "http://api.openweathermap.org/data/2.5/weather?appid=KeyForOpenWeatherMap&lat=23&lon=54&units=metric"
    expect(subject.send(:url)).to eq(url)
  end

  describe '.fetch_forecast_data' do
    it 'returns correct forecast data' do
      data = {
        'weather' => [
          {'main' => 'rain'}
        ],
        'main' => {
          'temp_min' => 21,
          'temp_max' => 24,
        }
      }
      allow_any_instance_of(HttpExecutor).to receive(:call).and_return(RestClient::Response.new(data.to_json))
      allow_any_instance_of(RestClient::Response).to receive(:body).and_return(data.to_json)

      expect(subject.fetch_forecast_data).to eq(provider: "openweathermap", precipType: "rain", t_min: 21, t_max:24, precipProbability: nil)
    end

    it 'returns nil for invalid response data' do
      data = {
        'wrong_data' => {
          'precipType' => 'rain',
          'temperatureMin' => 21,
          'temperatureMax' => 24,
          'precipProbability' => 0.5
        }
      }

      allow_any_instance_of(HttpExecutor).to receive(:call).and_return(RestClient::Response.new(data.to_json))
      allow_any_instance_of(RestClient::Response).to receive(:body).and_return(data.to_json)

      expect {subject.fetch_forecast_data}.not_to raise_error(Exceptions::InvalidFormat)
      expect(subject.fetch_forecast_data).to be(nil)
    end
  end
end
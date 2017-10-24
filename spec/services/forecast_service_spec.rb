require 'rails_helper'

RSpec.describe Queries::ForecastService do
  let!(:forecast_log) { create(:forecast_log, forecasts: []) }
  subject {described_class.new forecast_log.id}

  it 'assigns @current_log on initialize' do
    expect(subject.instance_variable_get(:@current_log)).to eq(forecast_log)
  end

  it 'returns list of third party apis classes' do
    expect(subject.send(:third_party_apis)).to eq([ThirdPartyApi::Darksky, ThirdPartyApi::OpenWeatherMap])
  end

  it "returns updated and 'dirty' forecast_log instance" do
    forecasts = [
      {
        'provider' => 'darksky',
        'precipType' => 'rain',
        't_min' => 15.56,
        't_max' => 19.48,
        'precipProbability' => 0.94
      },
      {
        'provider' => 'openweathermap',
        'precipType' => 'Clouds',
        't_min' => 15,
        't_max' => 18,
        'precipProbability' => nil
      }
    ]

    allow_any_instance_of(ThirdPartyApi::Darksky).to receive(:fetch_forecast_data).and_return(forecasts.first)
    allow_any_instance_of(ThirdPartyApi::OpenWeatherMap).to receive(:fetch_forecast_data).and_return(forecasts.last)

    expect(subject.fetch.forecasts.first).to match_array(forecasts.first)
    expect(subject.fetch.changed?).to be(true)
  end
end
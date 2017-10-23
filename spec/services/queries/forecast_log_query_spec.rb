require 'rails_helper'

RSpec.describe Queries::ForecastLogQuery do
  let(:city) { { 'id' => 'second_city_id', 'lng' => 23.04578, 'lat' => 44.39999, 'localeFullName' => 'City, Name' } }
  let!(:user_forecast_log_1) { create(:forecast_log) }
  let!(:user_forecast_log_2) { create(:forecast_log, city: city)}
  let!(:foreign_log) { create(:forecast_log, session_id: "some_id") }

  let(:query) { described_class.new }

  describe '.find_by_session' do
    it 'returns users logs sorted by desc' do
      expect(query.find_by_session(user_forecast_log_1.session_id).to_a).to eq([user_forecast_log_2, user_forecast_log_1])
      expect(query.find_by_session(user_forecast_log_1.session_id).to_a).not_to include(foreign_log)
    end
  end

  describe '.find_or_create' do
    context 'user session' do
      it 'returns existed log for city' do
        log = query.find_or_create(user_forecast_log_1.city, user_forecast_log_1.session_id)

        expect(log).to eq(user_forecast_log_1)
        expect(log.persisted?).to be(true)
      end

      it 'returns new log with empty forecasts for new city' do
        new_city = { 'id' => 'new_city_id', 'lng' => 23.04578, 'lat' => 44.39999, 'localeFullName' => 'City, Name' }
        log = query.find_or_create(new_city, user_forecast_log_1.session_id)

        expect(log.forecasts).to eq([])
        expect(log.persisted?).to be(false)
      end
    end

    context 'foreign session' do
      it 'returns new log with forecast copied from existed log' do
        log = query.find_or_create(city, foreign_log.session_id)

        expect(log.forecasts).to eq(user_forecast_log_2.forecasts)
        expect(log.city).to eq(city)
        expect(log.persisted?).to be(false)
      end
    end
  end
end
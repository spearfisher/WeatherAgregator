require 'rails_helper'

RSpec.describe ForecastLog, type: :model do
  it { is_expected.to be_mongoid_document }

  it { is_expected.to have_field(:session_id).of_type(String) }
  it { is_expected.to have_field(:forecasts).of_type(Array) }
  it { is_expected.to have_field(:city).of_type(Hash) }


  it { should validate_presence_of(:session_id) }

  it 'raises an error if city is invalid' do
    log = build(:forecast_log, city: {})
    log.valid?

    ForecastLog::CITY_KEYS.each do |key|
      expect(log.errors.messages).to include(key.to_sym => ["City #{key} can't be blank"])
    end

    expect { log.save.to raise_error(Mongoid::Errors::Validations) }
  end

  it "should have a frozen list of City keys" do
    expect(ForecastLog::CITY_KEYS).to eq(%w[id lng lat localeFullName])
    expect{ForecastLog::CITY_KEYS << "some_key"}.to raise_error(RuntimeError)
  end
end

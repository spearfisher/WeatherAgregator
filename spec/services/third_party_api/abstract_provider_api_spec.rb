require 'rails_helper'

RSpec.describe ThirdPartyApi::AbstractProviderApi do
  subject {described_class.new(23, 54)}

  it 'assigns @latitude and @longitude on initialize' do
    expect(subject.instance_variable_get(:@latitude)).to eq(23)
    expect(subject.instance_variable_get(:@longitude)).to eq(54)
  end

  it 'rise exception on fetch_forecast_data call' do
    expect { subject.fetch_forecast_data }.to raise_error(NotImplementedError)
    expect { subject.send(:prepare, nil) }.to raise_error(NotImplementedError)
    expect { subject.send(:url) }.to raise_error(NotImplementedError)
  end
end
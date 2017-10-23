FactoryBot.define do
  factory :forecast_log do
    session_id '2b1396ec1670e771a1716676c189c684'
    city do
      {
        'id' => '0dcc4365b6c93f34062e6ace3f04cc6df5ab7450',
        'lng' => -83.0457538,
        'lat' => 42.33142699999999,
        'localeFullName' => 'Detroit, MI, United States'
      }
    end
    forecasts [
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
  end
end

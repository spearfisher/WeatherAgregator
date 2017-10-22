class ForecastService
  def initialize(forecast_log_id)
    @current_log = ForecastLog.find(forecast_log_id)
  end

  def fetch
    third_party_apis.each do |api|
      provider = api.new(@current_log.city['lat'], @current_log.city['lng'])
      @current_log.forecasts << provider.fetch_forecast_data
    end

    @current_log
  end

  private

  def third_party_apis
    [ThirdPartyApi::Darksky, ThirdPartyApi::OpenWeatherMap]
  end
end

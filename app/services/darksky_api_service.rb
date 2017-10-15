class DarkskyApiService
  PROVIDER = 'darksky'.freeze
  BASE_URL = 'https://api.darksky.net/forecast'.freeze
  API_KEY = ENV['DARSKY_API_KEY'].freeze
  QUERY_PARAMS = 'exclude=minutely,currently,hourly,flags&units=si'.freeze

  def initialize(lat, lng)
    @latitude = lat
    @longitude = lng
  end

  def fetch_forecast_data
    response = http_executor.call
    prepare(response.body) if response
  rescue WeatherAggregator::InvalidFormat => e
    logger.error e
  end

  private

  def url
    "#{BASE_URL}/#{API_KEY}/#{@latitude},#{@longitude}?#{QUERY_PARAMS}"
  end

  def http_executor
    HttpExecutor.new(url)
  end

  def prepare(body)
    parsed_data = JSON.parse(body)
    return if parsed_data['error']

    daily_forecast = parsed_data['daily']['data'].first

    {
      precipType: daily_forecast['precipType'],
      t_min: daily_forecast['temperatureMin'],
      t_max: daily_forecast['temperatureMax'],
      precipProbability: daily_forecast['precipProbability']
    }
  rescue StandardError => e
    logger.error e
    raise WeatherAggregator::InvalidFormat, "Can't parse data from #{PROVIDER.capitalize} provider. Wrong data format."
  end
end

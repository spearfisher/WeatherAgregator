module ThirdPartyApi
  class OpenWeatherMap
    PROVIDER = 'openweathermap'.freeze
    BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'.freeze
    API_KEY = ENV['OPEN_WEATHER_MAP_API_KEY'].freeze
    QUERY_PARAMS = 'units=metric'.freeze

    def initialize(lat, lng)
      @latitude = lat
      @longitude = lng
    end

    def fetch_forecast_data
      response = http_executor.call
      prepare(response.body) if response
    rescue Exceptions::InvalidFormat => e
      logger.error e
    end

    private

    def url
      "#{BASE_URL}?appid=#{API_KEY}&lat=#{@latitude}&lon=#{@longitude}&#{QUERY_PARAMS}"
    end

    def http_executor
      HttpExecutor.new(url)
    end

    def prepare(body)
      parsed_data = JSON.parse(body)
      return if parsed_data['message']

      {
        precipType: parsed_data['weather'].first['main'],
        t_min: parsed_data['main']['temp_min'],
        t_max: parsed_data['main']['temp_max'],
        precipProbability: nil # As OpenWeatherMap don't have precipitation probability parameter
      }
    rescue StandardError => e
      logger.error e
      raise Exceptions::InvalidFormat, "Can't parse data from #{PROVIDER.upcase} provider. Wrong data format."
    end
  end
end

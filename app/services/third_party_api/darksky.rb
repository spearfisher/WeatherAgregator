module ThirdPartyApi
  class Darksky < AbstractProviderApi
    PROVIDER = 'darksky'.freeze
    BASE_URL = 'https://api.darksky.net/forecast'.freeze
    API_KEY = ENV['DARKSKY_API_KEY'].freeze
    QUERY_PARAMS = 'exclude=minutely,currently,hourly,flags&units=si'.freeze

    private

    def url
      "#{BASE_URL}/#{API_KEY}/#{@latitude},#{@longitude}?#{QUERY_PARAMS}"
    end

    def prepare(body)
      parsed_data = JSON.parse(body)
      return if parsed_data['error']

      daily_forecast = parsed_data['daily']['data'].first

      {
        provider: PROVIDER,
        precipType: daily_forecast['precipType'],
        t_min: daily_forecast['temperatureMin'],
        t_max: daily_forecast['temperatureMax'],
        precipProbability: daily_forecast['precipProbability']
      }
    rescue StandardError => e
      Rails.logger.error e
      raise Exceptions::InvalidFormat, "Can't parse data from #{PROVIDER.upcase} provider. Wrong data format."
    end
  end
end

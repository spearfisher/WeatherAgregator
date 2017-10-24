module ThirdPartyApi
  class AbstractProviderApi
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

    protected

    def http_executor
      HttpExecutor.new(url)
    end

    private

    def prepare(body)
      raise NotImplementedError
    end

    def url
      raise NotImplementedError
    end
  end
end
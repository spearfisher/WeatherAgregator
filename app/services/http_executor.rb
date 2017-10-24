class HttpExecutor
  def initialize(url, method=:get, headers={})
    @url = url
    @method = method
    @headers = headers
  end

  def call
    RestClient::Request.execute(url: @url, method: @method, headers: @headers)
  rescue RestClient::Exception => e
    Rails.logger.error e
    nil
  end
end

class ForecastWorker
  include Sidekiq::Worker

  def perform(forecast_log_id)
    forecast_log = ForecastService.new(forecast_log_id).fetch
    forecast_log.update

    ChannelNotificationService.call(forecast_log.session_id, data: forecast_log)
  end
end

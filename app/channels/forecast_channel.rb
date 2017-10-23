class ForecastChannel < ApplicationCable::Channel
  def subscribed
    stream_from "forecast_channel_#{current_session_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def fetch_forecast(data)
    @current_log = Queries::ForecastLogQuery.new.find_or_create(data['city'], current_session_id)

    if @current_log.persisted? || @current_log.forecasts.any? && @current_log.save
      ChannelNotificationService.call(current_session_id, data: @current_log) && return
    elsif @current_log.save
      ForecastWorker.perform_async(@current_log.id.to_s)
    else
      ChannelNotificationService.call(current_session_id, error: @current_log.errors.first)
    end
  end
end

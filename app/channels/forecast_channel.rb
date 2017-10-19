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
      notify_subscriber(@current_log) && return
    elsif @current_log.save
      ForecastWorker.perform_async(@current_log.id.to_s)
    else
      notify_subscriber(error: @current_log.errors.first)
    end
  end

  private

  def notify_subscriber(data)
    ActionCable.server.broadcast("forecast_channel_#{current_session_id}", data: data)
  end
end

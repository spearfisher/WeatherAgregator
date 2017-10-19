class ForecastChannel < ApplicationCable::Channel
  EXPIRATION_THRESHOLD = 4.hours

  def subscribed
    stream_from "forecast_channel_#{current_session_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def fetch_forecast(data)
    @current_log = existing_log(data) || ForecastLog.new(session_id: current_session_id, city: data['city'])

    if @current_log.persisted?
      notify_subscriber(@current_log) && return
    elsif @current_log.save
      ForecastWorker.perform_async(@current_log.id.to_s)
    else
      notify_subscriber(error: @current_log.errors.first)
    end
  end

  private

  def existing_log(data)
    @existing_log ||= ForecastLog
                      .actual(Time.now.utc - EXPIRATION_THRESHOLD)
                      .city(data['city']['id'])
                      .where(session_id: current_session_id)
                      .first
  end

  def notify_subscriber(data)
    ActionCable.server.broadcast("forecast_channel_#{current_session_id}", data: data)
  end
end

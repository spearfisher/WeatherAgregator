class ChannelNotificationService
  def self.call(session_id, data)
    ActionCable.server.broadcast("forecast_channel_#{session_id}", data)
  end
end

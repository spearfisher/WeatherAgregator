class ForecastLogsController < ApplicationController
  def index
    @forecast_logs = ForecastLog.where(session_id: session.id).order_by(created_at: 'desc')
  end
end

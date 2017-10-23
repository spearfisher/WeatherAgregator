class ForecastLogsController < ApplicationController
  def index
    @forecast_logs = Queries::ForecastLogQuery.new.find_by_session(session.id).to_a
  end
end

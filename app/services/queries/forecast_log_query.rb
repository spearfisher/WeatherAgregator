module Queries
  class ForecastLogQuery
    EXPIRATION_THRESHOLD = 4.hours.freeze

    def find_or_create(city, session_id)
      existing_logs(city['id']).each do |log|
        return log if log.session_id == session_id
      end

      @current_log = ForecastLog.new(session_id: session_id, city: city)

      @current_log.forecasts = @existing_log.first.forecasts if @existing_log.first

      @current_log
    end

    def find_by_session(id)
      ForecastLog.where(session_id: id).order_by(created_at: 'desc')
    end

    private

    def existing_logs(city_id)
      @existing_log ||= ForecastLog
                        .where(:created_at.gte => Time.now.utc - EXPIRATION_THRESHOLD)
                        .where('city.id' => city_id)
                        .to_a
    end
  end
end

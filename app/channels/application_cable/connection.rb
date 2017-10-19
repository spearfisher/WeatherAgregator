module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_session_id

    def connect
      self.current_session_id = session_id
    end

    private

    def session_id
      key = Rails.application.config.session_options.fetch(:key)
      session_hash = cookies.encrypted[key]&.symbolize_keys || {}
      session_hash[:session_id]
    end
  end
end

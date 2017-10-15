class ForecastLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :session_id, type: String
  field :city, type: Hash
  field :forecasts, type: Array

  index({ session_id: 1 }, name: 'session_id_index')
end

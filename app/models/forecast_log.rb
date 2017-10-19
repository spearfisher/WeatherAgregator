class ForecastLog
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  CITY_KEYS = %w[id lng lat localeFullName].freeze

  field :session_id, type: String
  field :city, type: Hash
  field :forecasts, type: Array, default: []

  attr_readonly :session_id, :city, :forecasts
  index({ session_id: 1 }, name: 'session_id_index')

  validate :city_check
  validates :session_id, presence: true

  scope :city, ->(id) { where('city.id' => id) }
  scope :actual, ->(date) { where(:created_at.gte => date) }

  private

  def city_check
    CITY_KEYS.each do |key|
      errors.add(key, "City #{key} can't be blank") if city[key].blank?
    end
  end
end

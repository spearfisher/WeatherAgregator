class ForecastLogsController < ApplicationController
  def index
    # TODO: find forecast logs for session.id
  end

  private

  def permitted_params
    @permit_params ||= params.permit(:id, :lng, :lat, :localeFullName)
  end
end

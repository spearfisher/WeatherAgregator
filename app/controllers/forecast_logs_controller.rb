class ForecastLogsController < ApplicationController
  def create
    forecast_service = DarkskyApiService.new(permitted_params['lat'], permitted_params['lat'])
    render json: forecast_service.fetch_forecast_data
  end

  private

  def permitted_params
    @permit_params ||= params.permit(:id, :lng, :lat, :localeFullName)
  end
end

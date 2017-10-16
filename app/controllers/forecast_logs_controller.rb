class ForecastLogsController < ApplicationController
  def create
    # TODO: Refactor code to use one service (ForecastResolverService) to get data from all API services or DB
    forecast_service = ThirdPartyApi::Darksky.new(permitted_params['lat'], permitted_params['lat'])
    open_fs = ThirdPartyApi::OpenWeatherMap.new(permitted_params['lat'], permitted_params['lat'])
    render json: {
      ThirdPartyApi::Darksky::PROVIDER => forecast_service.fetch_forecast_data,
      ThirdPartyApi::OpenWeatherMap::PROVIDER => open_fs.fetch_forecast_data
    }
  end

  private

  def permitted_params
    @permit_params ||= params.permit(:id, :lng, :lat, :localeFullName)
  end
end

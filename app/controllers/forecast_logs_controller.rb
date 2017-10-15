class ForecastLogsController < ApplicationController

  def create
    render :json => { :success => true, :logs => [{temp_min: 32, temp_max: 44, probPrec: 0.4}] }
  end

  private

  def permited_params
    @permit_params ||= params.permit(:id, :lng, :lat, :localeFullName)
  end
end

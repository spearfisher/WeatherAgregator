Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'forecast_logs#index'

  post 'forecast_logs', to: 'forecast_logs#create'
end

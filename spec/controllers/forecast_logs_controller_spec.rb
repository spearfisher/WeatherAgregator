require 'rails_helper'

RSpec.describe ForecastLogsController, type: :controller do
  describe 'GET index' do
    it 'assigns @forecast_logs' do
      user_log_1, user_log_2 = create(:forecast_log), create(:forecast_log)
      foreign_log = create(:forecast_log, session_id: "some_id")

      allow(session).to receive(:id).and_return(user_log_1.session_id)

      get :index
      expect(assigns(:forecast_logs)).to eq([user_log_2, user_log_1])
      expect(assigns(:forecast_logs)).not_to include(foreign_log)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end

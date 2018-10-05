require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller, sign_in: :admin_user do
  describe 'GET index' do
    render_views
    let!(:sellers) { create_list(:seller, 5) }
    let(:params) do
      {
        skip_filters: true,
      }
    end

    it 'is successful' do
      get :index, params: params
      expect(response).to be_success
    end
  end
end

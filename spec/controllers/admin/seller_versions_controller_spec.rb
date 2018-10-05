require 'rails_helper'

RSpec.describe Admin::SellerVersionsController, type: :controller, sign_in: :admin_user do
  describe 'GET index' do
    describe 'format CSV' do
      render_views

      let!(:seller_applications) { create_list(:seller_version, 5) }
      let(:params) do
        {
          # Reset the default filters
          skip_filters: true,
          format: :csv,
        }
      end

      it 'is successful' do
        get :index, params: params
        expect(response).to be_success
      end

      it 'sets the Content-Disposition header correctly' do
        time = Time.now

        Timecop.freeze(time) do
          get :index, params: params
        end
        expected = "attachment; filename=seller-applications-skip-filters-true-#{time.to_i}.csv"

        expect(response.headers['Content-Disposition']).to eq(expected)
      end

      it 'returns a valid CSV file' do
        get :index, params: params
        csv = CSV.parse(response.body)

        # NOTE: There are 6 rows (including the header row)
        #
        expect(csv.size).to eq(6)
      end
    end
  end
end

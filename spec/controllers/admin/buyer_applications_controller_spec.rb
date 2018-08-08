require 'rails_helper'

RSpec.describe Admin::BuyerApplicationsController, type: :controller, sign_in: :admin_user do

  describe 'GET index' do
    describe 'format CSV' do
      render_views

      let!(:buyer_applications) { create_list(:buyer_application, 5) }
      let(:params) {
        {
          # Reset the default filters
          skip_filters: true,
          format: :csv,
        }
      }

      it 'is successful' do
        get :index, params: params
        expect(response).to be_success
      end

      it 'sets the Content-Disposition header correctly' do
        time = Time.now

        Timecop.freeze(time) do
          get :index, params: params
        end
        expected = "attachment; filename=buyer-applications-skip-filters-true-#{time.to_i}.csv"

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

  describe 'POST deactivate' do
    let(:application) { create(:approved_buyer_application) }

    describe 'on success' do

      it 'redirects to the buyer page' do
        post :deactivate, params: { id: application.id }

        expect(response).to redirect_to(admin_buyer_application_path(application))
      end

      it 'sets a success flash notice' do
        expect(I18n).to receive(:t).with(/deactivate_success$/).and_return('String')

        post :deactivate, params: { id: application.id }

        expect(controller.flash.notice).to eq('String')
      end
    end

  end

end

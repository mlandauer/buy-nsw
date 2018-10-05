require 'rails_helper'

RSpec.describe Sellers::ProfilesController, type: :controller do
  describe 'GET show' do
    let(:seller) { create(:active_seller) }

    context 'given a seller with an approved version' do
      let!(:seller_version) { create(:approved_seller_version, seller: seller) }

      it 'returns an HTTP OK status' do
        get :show, params: { id: seller.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given a seller with no approved version' do
      let!(:seller_version) { create(:created_seller_version, seller: seller) }

      it 'returns a HTTP Not Found status' do
        get :show, params: { id: seller.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'given a seller which does not exist' do
      it 'returns a HTTP Not Found status' do
        get :show, params: { id: '1234567' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

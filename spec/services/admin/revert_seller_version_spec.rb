require 'rails_helper'

RSpec.describe Admin::RevertSellerVersion do

  let(:current_user) { create(:admin_user) }
  let(:version) { create(:approved_seller_version, assigned_to: current_user) }
  let!(:product) { create(:active_product, seller: version.seller) }

  describe '.call' do
    def perform_operation
      described_class.call(
        seller_version_id: version.id,
        current_user: current_user,
      )
    end

    context 'with valid attributes' do
      let!(:operation) { perform_operation }

      it 'is successful' do
        expect(operation).to be_success
        expect(operation).to_not be_failure
      end

      it 'transitions to the "created" state' do
        expect(operation.seller_version.state).to eq('created')
      end

      it 'logs an event' do
        expect(version.events.first.user).to eq(current_user)
        expect(version.events.first.message).to match('Deactivated seller')
      end

      it 'makes the products inactive' do
        expect(product.reload.state).to eq('inactive')
      end

      it 'makes the seller inactive' do
        expect(version.seller.reload.state).to eq('inactive')
      end
    end

    context 'a version in another state' do
      let(:version) { create(:created_seller_version, assigned_to: current_user) }
      let!(:operation) { perform_operation }

      it 'fails' do
        expect(operation).to be_failure
      end
    end

    context 'when the user is not assigned' do
      let(:version) { create(:approved_seller_version, assigned_to: create(:user)) }
      let!(:operation) { perform_operation }

      it 'fails' do
        expect(operation).to be_failure
      end
    end
  end

end

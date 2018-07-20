require 'rails_helper'

RSpec.describe Ops::AssignSellerVersion do

  let(:version) { create(:awaiting_assignment_seller_version) }

  let(:current_user) { create(:admin_user) }
  let(:assignee_user) { create(:admin_user) }

  let(:valid_attributes) {
    { assigned_to_id: assignee_user.id }
  }

  describe '.call' do
    def perform_operation(attributes: valid_attributes)
      described_class.call(
        seller_version_id: version.id,
        current_user: current_user,
        attributes: attributes,
      )
    end

    context 'with valid attributes' do
      let!(:operation) { perform_operation }

      it 'is successful' do
        expect(operation).to be_success
        expect(operation).to_not be_failure
      end

      it 'assigns a user to the version' do
        expect(operation.seller_version.assigned_to).to eq(assignee_user)
      end

      it 'transitions to the "ready_for_review" state' do
        expect(operation.seller_version.state).to eq('ready_for_review')
      end

      it 'logs an event' do
        expect(version.events.first.user).to eq(current_user)
        expect(version.events.first.message).to eq("Assigned application to #{assignee_user.email}")
      end
    end

    context 'a "ready_for_review" version' do
      let(:version) { create(:ready_for_review_seller_version) }
      let!(:operation) { perform_operation }

      it 'stays in the "ready_for_review_state"' do
        expect(operation.seller_version.state).to eq('ready_for_review')
      end
    end

    context 'a version in another state' do
      let(:version) { create(:created_seller_version) }
      let!(:operation) { perform_operation }

      it 'does not transition the state' do
        expect(operation.seller_version.state).to eq('created')
      end
    end

    context 'with invalid attributes' do
      let!(:operation) { perform_operation(attributes: { assigned_to_id: nil }) }

      it 'fails' do
        expect(operation).to be_failure
      end
    end

    context 'when the BuildAssignSellerVersion service fails' do
      before(:each) do
        expect(Ops::BuildAssignSellerVersion).to receive(:call).
          with(seller_version_id: version.id).
          and_return(
            double(success?: false, failure?: true)
          )
      end

      it 'fails' do
        expect(perform_operation).to be_failure
      end
    end
  end

end

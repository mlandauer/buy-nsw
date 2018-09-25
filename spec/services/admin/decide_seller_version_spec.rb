require 'rails_helper'

RSpec.describe Admin::DecideSellerVersion do
  include ActiveJob::TestHelper

  let(:version) { create(:ready_for_review_seller_version) }
  let(:current_user) { create(:admin_user) }

  describe '.call' do
    def perform_operation(attributes:)
      described_class.call(
        seller_version_id: version.id,
        current_user: current_user,
        attributes: attributes,
      )
    end

    context 'approving an application' do
      let(:operation) {
        perform_operation(attributes: {
          decision: 'approve',
          response: 'Response',
        })
      }

      it 'is successful' do
        expect(operation).to be_success
        expect(operation).to_not be_failure
      end

      it 'transitions to the "approved" state' do
        expect(operation.seller_version.state).to eq('approved')
      end

      it 'transitions the seller to the "active" state' do
        expect(operation.seller_version.seller.state).to eq('active')
      end

      it 'logs an event' do
        expect(operation.seller_version.events.first.user).to eq(current_user)
        expect(operation.seller_version.events.first.message).to eq("Approved application. Response: Response")
      end

      it 'sends an email' do
        expect {
          perform_enqueued_jobs { operation }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'sets a timestamp' do
        time = Time.now

        Timecop.freeze(time) do
          operation
        end

        expect(operation.seller_version.decided_at.to_i).to eq(time.to_i)
      end
    end

    context 'rejecting an application' do
      let(:operation) {
        perform_operation(attributes: {
          decision: 'reject',
          response: 'Response',
        })
      }

      it 'is successful' do
        expect(operation).to be_success
      end

      it 'transitions to the "rejected" state' do
        expect(operation.seller_version.state).to eq('rejected')
      end

      it 'logs an event' do
        expect(operation.seller_version.events.first.user).to eq(current_user)
        expect(operation.seller_version.events.first.message).to eq("Rejected application. Response: Response")
      end

      it 'sends an email' do
        expect {
          perform_enqueued_jobs { operation }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'returning an application for changes' do
      let(:operation) {
        perform_operation(attributes: {
          decision: 'return_to_applicant',
          response: 'Response',
        })
      }

      it 'is successful' do
        expect(operation).to be_success
      end

      it 'transitions to the "archived" state' do
        expect(operation.seller_version.state).to eq('archived')
      end

      it 'creates a new version of the application' do
        expect(operation.seller_version.next_version).to_not be_nil
        expect(operation.seller_version.next_version.previous_version).to eq(operation.seller_version)
        expect(operation.seller_version.next_version.state).to eq('created')
      end

      it 'logs an event' do
        expect(operation.seller_version.events.first.user).to eq(current_user)
        expect(operation.seller_version.events.first.message).to eq("Returned application to seller. Response: Response")
      end

      it 'sends an email' do
        expect {
          perform_enqueued_jobs { operation }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end

end

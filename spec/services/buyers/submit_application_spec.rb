require 'rails_helper'

RSpec.describe Buyers::SubmitApplication do
  include ActiveJob::TestHelper

  subject { perform_operation(user: buyer_user) }

  let(:buyer_user) { create(:buyer_user) }
  let!(:application) { create(:completed_buyer_application, user: buyer_user) }

  def perform_operation(user: buyer_user)
    described_class.call(user: user)
  end

  describe '.call' do
    context 'with a complete application' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'updates the state' do
        expect(subject.application.reload.state).to eq('awaiting_assignment')
      end

      it 'sends a Slack notification' do
        expect(SlackPostJob).to receive(:perform_later)
        subject
      end

      it 'logs an event' do
        expect(subject.application.events.first.user).to eq(buyer_user)
        expect(subject.application.events.first.message).to eq("Submitted application")
      end
    end

    context 'when manager approval is required' do
      let!(:application) do
        create(:completed_manager_approval_buyer_application, user: buyer_user)
      end

      it 'sends an email' do
        # NOTE: Stub the Slack job as it is automatically performed when we
        # run perform_enqueued_jobs
        allow(SlackPostJob).to receive(:perform_later)

        expect do
          perform_enqueued_jobs { subject }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'sets the manager approval token' do
        expect_any_instance_of(BuyerApplication).to receive(:set_manager_approval_token!)
        subject
      end
    end

    describe 'failure states' do
      it 'fails when the user is not present' do
        operation = perform_operation(user: nil)

        expect(operation).to be_failure
      end

      it 'fails when the application is not present' do
        other_user = create(:user)
        operation = perform_operation(user: other_user)

        expect(operation).to be_failure
      end

      it 'fails when the application is in the wrong state' do
        application.update_attribute(:state, 'awaiting_assignment')

        expect(perform_operation).to be_failure
      end

      it 'fails when the application is not complete' do
        mock_flow = double('Flow', valid?: false)
        allow(BuyerApplicationFlow).to receive(:new).and_return(mock_flow)

        expect(perform_operation).to be_failure
      end
    end
  end
end

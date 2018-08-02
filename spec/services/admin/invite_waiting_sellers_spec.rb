require 'rails_helper'

RSpec.describe Admin::InviteWaitingSellers do
  include ActiveJob::TestHelper

  let(:waiting_sellers) { create_list(:waiting_seller, 5) }
  let(:waiting_seller_ids) { waiting_sellers.map(&:id) }

  let(:token) { 'not a secret token' }

  describe '.call' do
    subject {
      described_class.call(waiting_seller_ids: waiting_seller_ids)
    }

    context 'given valid arguments' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'generates an invitation token' do
        allow(SecureRandom).to receive(:hex).and_return(token)

        subject.waiting_sellers.each do |seller|
          expect(seller.reload.invitation_token).to eq(token)
        end
      end

      it 'sets "invitation_state" of all sellers to "invited"' do
        subject.waiting_sellers.each do |seller|
          expect(seller.reload.invitation_state).to eq('invited')
        end
      end

      it 'sets the "invited_at" timestamp' do
        time = 1.hour.ago

        Timecop.freeze(time) do
          subject.waiting_sellers.each do |seller|
            expect(seller.reload.invited_at.to_i).to eq(time.to_i)
          end
        end
      end

      it 'sends an invitation email' do
        allow(WaitingSellerMailer).to receive(:with).
                                        with(waiting_seller: kind_of(WaitingSeller)).
                                        and_call_original

        expect {
          perform_enqueued_jobs { subject }
        }.to change { ActionMailer::Base.deliveries.count }.by(5)
      end
    end

    context 'when Admin::BuildInviteWaitingSellers fails' do
      before(:each) do
        expect(Admin::BuildInviteWaitingSellers).to receive(:call).
          with(waiting_seller_ids: waiting_seller_ids).
          and_return(
            double(success?: false, failure?: true)
          )
      end

      it 'fails' do
        expect(subject).to be_failure
      end
    end

  end

end

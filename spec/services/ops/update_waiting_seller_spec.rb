require 'rails_helper'

RSpec.describe Ops::UpdateWaitingSeller do

  let(:waiting_seller) { create(:waiting_seller) }
  let(:attributes) {
    attributes_for(:waiting_seller).slice(:name, :contact_name, :contact_email)
  }

  describe '.call' do
    context 'given valid attributes' do
      subject {
        described_class.call(
          waiting_seller_id: waiting_seller.id,
          attributes: attributes,
        )
      }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'persists the changes' do
        expect(subject.waiting_seller.reload.contact_email).
          to eq(attributes[:contact_email])
      end
    end

    context 'given invalid attributes' do
      subject {
        described_class.call(
          waiting_seller_id: waiting_seller.id,
          attributes: { contact_email: '' },
        )
      }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when Ops::BuildUpdateWaitingSeller fails' do
      before(:each) do
        expect(Ops::BuildUpdateWaitingSeller).to receive(:call).
          with(waiting_seller_id: waiting_seller.id, skip_prevalidate: true).
          and_return(
            double(success?: false, failure?: true)
          )
      end

      subject {
        described_class.call(
          waiting_seller_id: waiting_seller.id,
          attributes: attributes,
        )
      }

      it 'fails' do
        expect(subject).to be_failure
      end
    end
  end

end

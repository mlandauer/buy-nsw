require 'rails_helper'

RSpec.describe Admin::UpdateWaitingSeller do
  let(:waiting_seller) { create(:waiting_seller) }
  let(:attributes) do
    attributes_for(:waiting_seller).slice(:name, :contact_name, :contact_email)
  end

  describe '.call' do
    context 'given valid attributes' do
      subject do
        described_class.call(
          waiting_seller_id: waiting_seller.id,
          attributes: attributes,
        )
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'persists the changes' do
        expect(subject.waiting_seller.reload.contact_email).
          to eq(attributes[:contact_email])
      end
    end

    context 'given invalid attributes' do
      subject do
        described_class.call(
          waiting_seller_id: waiting_seller.id,
          attributes: { contact_email: '' },
        )
      end

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when Admin::BuildUpdateWaitingSeller fails' do
      subject do
        described_class.call(
          waiting_seller_id: waiting_seller.id,
          attributes: attributes,
        )
      end

      before(:each) do
        expect(Admin::BuildUpdateWaitingSeller).to receive(:call).
          with(waiting_seller_id: waiting_seller.id, skip_prevalidate: true).
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

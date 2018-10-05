require 'rails_helper'

RSpec.describe Buyers::UpdateApplication do
  let(:buyer_user) { create(:inactive_buyer_user) }
  let(:form) { BuyerApplications::BasicDetailsForm }
  let(:attributes) do
    attributes_for(:completed_buyer_application).slice(:name, :organisation)
  end

  describe '.call' do
    context 'given valid attributes' do
      subject do
        described_class.call(
          user: buyer_user,
          form_class: form,
          attributes: attributes,
        )
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'persists the changes' do
        expect(subject.application.reload.name).to eq(attributes[:name])
      end
    end

    context 'given invalid attributes' do
      subject do
        described_class.call(
          user: buyer_user,
          form_class: form,
          attributes: { name: '' },
        )
      end

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when Buyers::BuildUpdateApplication fails' do
      subject do
        described_class.call(
          user: buyer_user,
          form_class: form,
          attributes: attributes,
        )
      end

      before(:each) do
        expect(Buyers::BuildUpdateApplication).to receive(:call).
          with(user: buyer_user, form_class: form).
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

require 'rails_helper'

RSpec.describe Sellers::Applications::DashboardPresenter do
  subject { described_class.new(seller_version, steps) }

  let(:seller_version) { create(:created_seller_version) }
  let(:steps) do
    Sellers::Applications::StepsController.steps(seller_version)
  end

  describe '#ineligible?' do
    context 'when the "services" step has not been started' do
      before(:each) do
        mock_step = double('step', started?: false)
        allow(subject).to receive(:step).with('services').and_return(mock_step)
      end

      it 'returns false' do
        expect(subject.ineligible?).to be_falsey
      end
    end

    context 'when the "services" step has been started' do
      before(:each) do
        mock_step = double('step', started?: true)
        allow(subject).to receive(:step).with('services').and_return(mock_step)
      end

      context 'for an ineligible seller' do
        before(:each) do
          seller_version.update_attribute(:services, [])
        end

        it 'returns true' do
          expect(subject.ineligible?).to be_truthy
        end
      end

      context 'for an eligible seller' do
        before(:each) do
          seller_version.update_attribute(:services, ['cloud-services'])
        end

        it 'returns false' do
          expect(subject.ineligible?).to be_falsey
        end
      end
    end
  end
end

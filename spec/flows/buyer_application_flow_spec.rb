require 'rails_helper'

RSpec.describe BuyerApplicationFlow do
  subject { described_class.new(application) }

  let(:application) { build_stubbed(:buyer_application) }

  before(:each) do
    allow(application).to receive(:reload).and_return(application)
  end

  describe '#steps' do
    it 'returns an array of steps' do
      expect(subject.steps).to be_a(Array)
    end

    context 'when manager approval is required' do
      before(:each) do
        expect(application).to receive(:requires_manager_approval?).and_return(true)
      end

      it 'includes the manager approval form' do
        expect(subject.steps).to include(BuyerApplications::ManagerApprovalForm)
      end
    end

    context 'when manager approval is not required' do
      before(:each) do
        expect(application).to receive(:requires_manager_approval?).and_return(false)
      end

      it 'includes the manager approval form' do
        expect(subject.steps).not_to include(BuyerApplications::ManagerApprovalForm)
      end
    end
  end

  describe '#valid?' do
    context 'when all steps are valid' do
      let(:valid_form) { double(valid?: true) }

      before(:each) do
        subject.steps.each do |step|
          expect(step).to receive(:new).with(application).and_return(valid_form)
        end
      end

      it 'is true' do
        expect(subject).to be_valid
      end
    end

    context 'when all steps are invalid' do
      let(:invalid_form) { double(valid?: false) }

      before(:each) do
        subject.steps.each do |step|
          expect(step).to receive(:new).with(application).and_return(invalid_form)
        end
      end

      it 'is false' do
        expect(subject).not_to be_valid
      end
    end
  end
end

require 'rails_helper'

RSpec.describe BuyerApplicationFlow do

  let(:application) { build_stubbed(:buyer_application) }

  before(:each) {
    allow(application).to receive(:reload).and_return(application)
  }

  subject { described_class.new(application) }

  describe '#steps' do
    it 'returns an array of steps' do
      expect(subject.steps).to be_a(Array)
    end

    context 'when manager approval is required' do
      before(:each) {
        expect(application).to receive(:requires_manager_approval?).and_return(true)
      }

      it 'includes the manager approval form' do
        expect(subject.steps).to include(BuyerApplications::ManagerApprovalForm)
      end
    end

    context 'when manager approval is not required' do
      before(:each) {
        expect(application).to receive(:requires_manager_approval?).and_return(false)
      }

      it 'includes the manager approval form' do
        expect(subject.steps).to_not include(BuyerApplications::ManagerApprovalForm)
      end
    end
  end

  describe '#valid?' do
    context 'when all steps are valid' do
      let(:valid_form) { double(valid?: true) }

      before(:each) {
        subject.steps.each do |step|
          expect(step).to receive(:new).with(application).and_return(valid_form)
        end
      }

      it 'is true' do
        expect(subject).to be_valid
      end
    end

    context 'when all steps are invalid' do
      let(:invalid_form) { double(valid?: false) }

      before(:each) {
        subject.steps.each do |step|
          expect(step).to receive(:new).with(application).and_return(invalid_form)
        end
      }

      it 'is false' do
        expect(subject).to_not be_valid
      end
    end
  end

end

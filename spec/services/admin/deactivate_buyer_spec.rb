require 'rails_helper'

RSpec.describe Admin::DeactivateBuyer do

  let(:application) { create(:approved_buyer_application) }

  describe '.call' do
    it 'changes the state of an application to `deactivated`' do
      result = described_class.call(buyer_application_id: application.id)

      expect(result).to be_success
      expect(application.reload.state).to eq('deactivated')
    end

    it 'fails when the application cannot move to the `deactivated` state' do
      application = create(:created_buyer_application)
      result = described_class.call(buyer_application_id: application.id)

      expect(result).to be_failure
    end
  end

end

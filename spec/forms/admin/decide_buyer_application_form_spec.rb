require 'rails_helper'

RSpec.describe Admin::DecideBuyerApplicationForm do
  let(:application) { build_stubbed(:buyer_application) }

  it 'is valid with a decision and decision_body' do
    form = described_class.new(application)

    form.validate(
      decision: 'approve',
      decision_body: 'Response',
    )

    expect(form).to be_valid
  end

  it 'is invalid without a decision' do
    form = described_class.new(application)

    form.validate(
      decision: nil,
    )

    expect(form).not_to be_valid
    expect(form.errors[:decision]).to be_present
  end

  it 'is invalid without a decision in the list' do
    form = described_class.new(application)

    form.validate(
      decision: 'blah',
    )

    expect(form).not_to be_valid
    expect(form.errors[:decision]).to be_present
  end
end

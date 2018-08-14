require 'rails_helper'

RSpec.describe Sellers::AcceptInvitationForm do
  let(:application) { build_stubbed(:seller_version) }
  let(:user) { build_stubbed(:seller_user, seller: application.seller) }

  subject { described_class.new(user) }

  let(:atts) {
    {
      password: 'foo bar baz',
      password_confirmation: 'foo bar baz',
    }
  }

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the password is blank' do
    subject.validate(atts.merge(password: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:password]).to be_present
  end

  it 'is invalid when the password_confirmation is blank' do
    subject.validate(atts.merge(password_confirmation: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:password_confirmation]).to be_present
  end

  it 'is invalid when passwords do not match' do
    subject.validate(atts.merge(password_confirmation: 'something else'))

    expect(subject).to_not be_valid
    expect(subject.errors[:password_confirmation]).to be_present
  end
end

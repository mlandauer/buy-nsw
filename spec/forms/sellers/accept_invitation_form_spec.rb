require 'rails_helper'

RSpec.describe Sellers::AcceptInvitationForm do
  subject { described_class.new(user) }

  let(:application) { build_stubbed(:seller_version) }
  let(:user) { build_stubbed(:seller_user, seller: application.seller) }

  let(:atts) do
    {
      password: 'foo bar baz',
      password_confirmation: 'foo bar baz',
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the password is blank' do
    subject.validate(atts.merge(password: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:password]).to be_present
  end

  it 'is invalid when the password_confirmation is blank' do
    subject.validate(atts.merge(password_confirmation: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:password_confirmation]).to be_present
  end

  it 'is invalid when passwords do not match' do
    subject.validate(atts.merge(password_confirmation: 'something else'))

    expect(subject).not_to be_valid
    expect(subject.errors[:password_confirmation]).to be_present
  end
end

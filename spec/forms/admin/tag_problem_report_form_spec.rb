require 'rails_helper'

RSpec.describe Admin::TagProblemReportForm do
  subject do
    described_class.new(problem_report)
  end

  let(:problem_report) { build_stubbed(:open_problem_report) }

  it 'is valid with tags' do
    subject.validate({
      tags: 'foo bar baz',
    })

    expect(subject).to be_valid
  end

  it 'parses a string of tags into an array' do
    subject.validate({
      tags: 'foo bar baz',
    })

    expect(subject.to_nested_hash['tags']).to contain_exactly('foo', 'bar', 'baz')
  end
end

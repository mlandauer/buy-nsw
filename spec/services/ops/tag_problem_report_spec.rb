require 'rails_helper'

RSpec.describe Ops::TagProblemReport do

  let(:problem_report) { create(:open_problem_report) }

  describe '.call' do
    let(:tags) { 'foo bar baz' }
    let(:operation) { described_class.call(problem_report_id: problem_report.id, tags: tags) }

    it 'is successful' do
      expect(operation).to be_success
    end

    it 'persists the tags to the report' do
      expect(operation.problem_report.reload.tags).to contain_exactly(*tags.split(' '))
    end

    context 'when the BuildTagProblemReport service fails' do
      before(:each) do
        expect(Ops::BuildTagProblemReport).to receive(:call).
          with(problem_report_id: problem_report.id).
          and_return(
            double(success?: false, failure?: true)
          )
      end

      it 'fails' do
        expect(operation).to be_failure
      end
    end
  end

end

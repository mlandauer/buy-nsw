require 'rails_helper'

RSpec.describe Admin::BuildTagProblemReport do

  let(:problem_report) { create(:open_problem_report) }

  subject { described_class.new(problem_report_id: problem_report.id) }

  describe '.call' do
    context 'given an existing problem_report' do
      let(:operation) { described_class.call(problem_report_id: problem_report.id) }

      it 'is successful' do
        expect(operation).to be_success
      end
    end

    context 'when the problem report does not exist' do
      it 'raises an exception' do
        expect{
          described_class.call(problem_report_id: '1234567')
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#form' do
    it 'returns a form for the problem report' do
      expect(subject.form).to be_a(Admin::TagProblemReportForm)
      expect(subject.form.model).to eq(problem_report)
    end
  end

  describe '#problem_report' do
    it 'returns the problem report' do
      expect(subject.problem_report).to eq(problem_report)
    end
  end

end

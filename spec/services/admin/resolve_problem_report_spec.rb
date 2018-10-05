require 'rails_helper'

RSpec.describe Admin::ResolveProblemReport do
  let(:user) { create(:admin_user) }
  let(:problem_report) { create(:open_problem_report) }

  describe '.call' do
    context 'given valid arguments' do
      let(:operation) do
        described_class.call(problem_report_id: problem_report.id, current_user: user)
      end

      it 'is successful' do
        expect(operation).to be_success
      end

      it 'changes the state of the report to `resolved`' do
        expect(operation.problem_report.reload.state).to eq('resolved')
      end

      it 'sets the resolved_at timestamp' do
        time = 1.day.ago

        Timecop.freeze(time) do
          expect(operation.problem_report.reload.resolved_at.to_i).to eq(time.to_i)
        end
      end

      it 'sets resolved_by to the current user' do
        expect(operation.problem_report.reload.resolved_by).to eq(user)
      end
    end

    context 'without a user' do
      let(:operation) do
        described_class.call(problem_report_id: problem_report.id, current_user: nil)
      end

      it 'fails' do
        expect(operation).to be_failure
      end
    end

    context 'without a problem report' do
      let(:operation) do
        described_class.call(problem_report_id: 'foo', current_user: user)
      end

      it 'fails' do
        expect { operation }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a problem report in the "resolved" state' do
      let(:resolved_problem_report) { create(:resolved_problem_report) }
      let(:operation) do
        described_class.call(problem_report_id: resolved_problem_report.id, current_user: user)
      end

      it 'fails' do
        expect(operation).to be_failure
      end
    end
  end
end

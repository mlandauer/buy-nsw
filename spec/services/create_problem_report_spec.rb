require 'rails_helper'

RSpec.describe CreateProblemReport do
  include ActiveJob::TestHelper

  let(:params) do
    {
      task: 'task',
      issue: 'issue',
      url: 'http://example.org',
      referer: 'http://example.org/referer',
      browser: 'ExampleBrowser/10.0',
    }
  end
  let(:user) { create(:seller_user) }

  describe '.call' do
    context 'with valid attributes' do
      let(:operation) do
        described_class.call(params: params, current_user: nil)
      end

      it 'is successful' do
        expect(operation).to be_success
      end

      it 'creates the report' do
        report = operation.problem_report.reload

        expect(report.task).to eq(params[:task])
        expect(report.issue).to eq(params[:issue])
        expect(report.url).to eq(params[:url])
        expect(report.referer).to eq(params[:referer])
        expect(report.browser).to eq(params[:browser])
      end

      it 'sends report to zendesk' do
        expect do
          perform_enqueued_jobs do
            operation
          end
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with a user object' do
      let(:operation) do
        described_class.call(params: params, current_user: user)
      end

      it 'assigns the user' do
        report = operation.problem_report.reload
        expect(report.user).to eq(user)
      end

      it 'sends report to zendesk' do
        expect do
          perform_enqueued_jobs do
            operation
          end
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with invalid attributes' do
      o
      let(:operation) do
        described_class.call(params: params.merge(task: nil, issue: nil), current_user: nil)
      end

      it 'fails' do
        expect(operation).to be_failure
      end
    end
  end
end

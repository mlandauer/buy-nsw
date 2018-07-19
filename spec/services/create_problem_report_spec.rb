require 'rails_helper'

RSpec.describe CreateProblemReport do

  let(:params) {
    {
      task: 'task',
      issue: 'issue',
      url: 'http://example.org',
      referer: 'http://example.org/referer',
      browser: 'ExampleBrowser/10.0',
    }
  }
  let(:user) { create(:seller_user) }

  describe '.call' do
    context 'with valid attributes' do
      let(:operation) {
        described_class.call(params: params, current_user: nil)
      }

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
    end

    context 'with a user object' do
      let(:operation) {
        described_class.call(params: params, current_user: user)
      }

      it 'assigns the user' do
        report = operation.problem_report.reload
        expect(report.user).to eq(user)
      end
    end

    context 'with invalid attributes' do
      let(:operation) {
        described_class.call(params: params.merge(task: nil, issue: nil), current_user: nil)
      }

      it 'fails' do
        expect(operation).to be_failure
      end
    end
  end

end

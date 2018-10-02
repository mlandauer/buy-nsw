require 'rails_helper'

RSpec.describe NewProblemMailer, type: :mailer do

  describe '#report_email' do
    let(:problem) { create(:problem_report) }

    let(:mail) { described_class.with(user: problem.user, task: problem.task, issue: problem.issue, url: problem.url).report_email }

    it 'renders the headers' do
      expect(mail.subject).to match("buy.nsw: A new problem was reported")
      expect(mail.reply_to).to contain_exactly(problem.user.email)
    end

    it 'should include the task and issue' do
      expect(mail.body.encoded).to match(problem.task)
      expect(mail.body.encoded).to match(problem.issue)
    end
  end
end

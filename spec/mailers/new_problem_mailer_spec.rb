require 'rails_helper'

RSpec.describe NewProblemMailer, type: :mailer do

  describe '#report_email' do
    let(:user) { create(:user) }
    let(:task) { 'doing something' }
    let(:issue) { 'something happened' }

    let(:mail) { described_class.with(user: user, task: task, issue: issue, url: 'http://localhost:3000/ops/problem-reports/5').report_email }

    it 'renders the headers' do
      expect(mail.subject).to match("buy.nsw: A new problem was reported")
      expect(mail.reply_to).to contain_exactly(user.email)
    end

    it 'should include the task and issue' do
      expect(mail.body.encoded).to match(task)
      expect(mail.body.encoded).to match(issue)
    end
  end
end

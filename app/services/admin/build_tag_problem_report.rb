class Admin::BuildTagProblemReport < ApplicationService
  def initialize(problem_report_id:)
    @problem_report_id = problem_report_id
  end

  def call
    if problem_report.present?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def form
    @form ||= Admin::TagProblemReportForm.new(problem_report)
  end

  def problem_report
    @problem_report ||= ProblemReport.find(problem_report_id)
  end

  private

  attr_reader :problem_report_id
end

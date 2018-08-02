class Admin::ResolveProblemReport < ApplicationService

  def initialize(problem_report_id:, current_user:)
    @problem_report_id = problem_report_id
    @current_user = current_user
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        validate_current_user
        validate_state
        update_state
        set_timestamp_and_user
        persist_report
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

  def problem_report
    @problem_report ||= ProblemReport.find(problem_report_id)
  end

private
  attr_reader :problem_report_id, :current_user

  def validate_current_user
    raise Failure unless current_user.present?
  end

  def validate_state
    raise Failure unless problem_report.may_resolve?
  end

  def update_state
    problem_report.resolve
  end

  def set_timestamp_and_user
    problem_report.resolved_at = Time.now
    problem_report.resolved_by = current_user
  end

  def persist_report
    raise Failure unless problem_report.save
  end

end

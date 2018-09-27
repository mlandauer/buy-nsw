class CreateProblemReport < ApplicationService
  def initialize(params:, current_user: nil)
    @params = params
    @current_user = current_user
  end

  def call
    assign_attributes
    persist_problem_report
    send_slack_notification

    self.state = :success
  rescue Failure
    self.state = :failure
  end

  def problem_report
    @problem_report ||= ProblemReport.new
  end

  private

  attr_reader :params, :current_user

  def report_params
    {
      task: params[:task],
      issue: params[:issue],
      url: params[:url],
      referer: params[:referer],
      browser: params[:browser],
      user: current_user,
    }
  end

  def assign_attributes
    problem_report.assign_attributes(report_params)
  end

  def persist_problem_report
    raise Failure unless problem_report.save
  end

  def send_slack_notification
    SlackPostJob.perform_later(problem_report.id, :new_problem_report.to_s)
  end
end

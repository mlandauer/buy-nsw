class Feedback::ProblemReportsController < ApplicationController
  def create
    operation = CreateProblemReport.call(
      params: params,
      current_user: current_user,
    )

    respond_to do |format|
      if operation.success?
        format.html do
          flash.notice = success_message
          redirect_to(root_path)
        end
        format.json do
          render status: 200, json: { message: success_message }
        end
      else
        format.html { render :new }
        format.json do
          render status: 422, json: { message: invalid_message }
        end
      end
    end
  end

  private

  def success_message
    I18n.t('feedback.problem_report.messages.success')
  end

  def invalid_message
    I18n.t('feedback.problem_report.messages.invalid')
  end
end

class Ops::ProblemReportsController < Ops::BaseController

  def index; end
  def show; end

  def resolve
    operation = Ops::ResolveProblemReport.call(
      problem_report_id: params[:id],
      current_user: current_user,
    )

    if operation.success?
      flash.notice = I18n.t('ops.problem_reports.messages.resolved')
    else
      flash.alert = I18n.t('ops.problem_reports.messages.resolve_failed')
    end

    redirect_to ops_problem_report_path(operation.problem_report)
  end

  def tag
    operation = run Ops::ProblemReport::Tag

    if operation.success?
      flash.notice = I18n.t('ops.problem_reports.messages.updated')
    else
      flash.alert = I18n.t('ops.problem_reports.messages.update_failed')
    end

    redirect_to ops_problem_report_path(operation['model'])
  end

private
  def search
    @search ||= Search::ProblemReport.new(
      selected_filters: params,
      default_values: {
        state: 'open',
      },
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end

  def problem_report
    @problem_report ||= ProblemReport.find(params[:id])
  end

  def tag_form
    @tag_form ||= Ops::BuildTagProblemReport.call(problem_report_id: params[:id]).form
  end

  helper_method :search, :problem_report, :tag_form

  def _run_options(options)
    options.merge('config.current_user' => current_user)
  end

end

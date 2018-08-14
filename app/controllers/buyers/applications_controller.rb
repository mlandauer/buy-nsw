class Buyers::ApplicationsController < Buyers::BaseController
  before_action :authenticate_user!, except: :manager_approve

  def new
    run Buyers::BuyerApplication::Create do |result|
      return redirect_to buyers_application_path(result[:application_model].id)
    end

    redirect_to buyers_dashboard_path
  end

  def show
    @operation = Buyers::BuildUpdateApplication.call(
      user: current_user,
      form_class: form_class,
    )
  end

  def update
    @operation = Buyers::UpdateApplication.call(
      user: current_user,
      form_class: form_class,
      attributes: params[:buyer_application],
    )

    if operation.success?
      if last_step?
        return redirect_to review_buyers_application_path(application)
      end

      return redirect_to buyers_application_step_path(application, next_step_slug)
    end

    render :show
  end

  def review; end

  def submit
    @operation = Buyers::SubmitApplication.call(user: current_user)

    if operation.success?
      return redirect_to buyers_dashboard_path
    end

    render :review
  end

  def manager_approve
    @operation = run Buyers::BuyerApplication::ManagerApprove

    flash.notice = (operation['result.approved'] == true) ?
      I18n.t('buyers.applications.messages.manager_approve_success') :
        I18n.t('buyers.applications.messages.manager_approve_failure')

    return redirect_to root_path
  end

private
  def operation
    @operation
  end
  helper_method :operation

  def application
    @application ||= BuyerApplication.created.find_by!(user: current_user)
  end
  helper_method :application

  def _run_options(options)
    options.merge(
      "current_user" => current_user,
    )
  end

  def form_class
    @form_class ||= steps.find {|step|
                      BuyerStepPresenter.new(step).slug == params[:step]
                    } || steps.first
  end
  helper_method :form_class

  def form
    operation.form
  end
  helper_method :form

  def presenter
    @presenter ||= BuyerStepPresenter.new(form_class)
  end
  helper_method :presenter

  def steps
    BuyerApplicationFlow.new(application).steps
  end
  helper_method :steps

  def next_step
    @next_step ||= steps[ steps.index(form_class) + 1 ]
  end
  helper_method :next_step

  def next_step_slug
    BuyerStepPresenter.new(next_step).slug
  end
  helper_method :next_step_slug

  def previous_step
    @previous_step ||= steps[ steps.index(form_class) - 1 ]
  end
  helper_method :previous_step

  def previous_step_slug
    BuyerStepPresenter.new(previous_step).slug
  end
  helper_method :previous_step_slug

  def last_step?
    form_class == steps.last
  end
  helper_method :last_step?

  def first_step?
    form_class == steps.first
  end
  helper_method :first_step?

end

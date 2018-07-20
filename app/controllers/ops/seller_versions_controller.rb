class Ops::SellerVersionsController < Ops::BaseController

  after_action :set_content_disposition, if: :csv_request?, only: :index

  layout ->{
    action_name == 'index' ? 'ops' : '../ops/seller_versions/_layout'
  }

  def index
    respond_to do |format|
      format.html
      format.csv
    end
  end

  def show
  end

  def assign
    run Ops::SellerVersion::Assign do |result|
      flash.notice = I18n.t('ops.seller_versions.messages.update_assign_success')
      return redirect_to ops_seller_application_path(application)
    end

    render :show
  end

  def decide
    operation = Ops::DecideSellerVersion.call(
      seller_version_id: params[:id],
      current_user: current_user,
      attributes: params[:seller_application],
    )

    if operation.success?
      decision = operation.form.decision
      flash.notice = I18n.t("ops.seller_versions.messages.decision_success.#{decision}")
      return redirect_to ops_seller_application_path(application)
    else
      render :show
    end
  end

  def notes
    application = SellerVersion.find(params[:id])
    event = Event::Note.create(
      user: current_user,
      eventable: application,
      note: params[:event_note]['note']
    )
    redirect_to ops_seller_application_path(application)
  end

private
  def applications
    @applications ||= SellerVersion.includes(:seller)
  end
  helper_method :applications

  def search
    @search ||= Search::Ops::SellerVersion.new(
      selected_filters: params,
      default_values: {
        state: 'ready_for_review',
        assigned_to: current_user.id,
      },
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

  def application
    @application ||= SellerVersion.find(params[:id])
  end
  helper_method :application

  def decorated_seller
    SellerDecorator.new(application.seller, view_context)
  end
  helper_method :decorated_seller

  def forms
    @forms ||= {
      assign: ops[:assign]['contract.default'],
      decide: decide_form,
    }
  end
  helper_method :forms

  def ops
    @ops ||= {
      assign: (run Ops::SellerVersion::Assign::Present),
    }
  end

  def decide_form
    @decide_form ||= Ops::BuildDecideSellerVersion.call(seller_version_id: params[:id]).form
  end
  helper_method :decide_form

  def _run_options(options)
    options.merge( "current_user" => current_user )
  end

  def csv_filename
    "seller-applications-#{search.selected_filters_string}-#{Time.now.to_i}.csv"
  end
end

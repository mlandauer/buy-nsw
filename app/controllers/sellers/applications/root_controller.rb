class Sellers::Applications::RootController < Sellers::Applications::BaseController
  before_action :assert_application_presence!, except: [:new, :create]

  def new
    @operation = run Sellers::SellerVersion::Create::Present

    if operation.failure?
      if operation['application_submitted']
        return redirect_to sellers_dashboard_path
      elsif operation['application_created']
        return redirect_to sellers_application_path(operation['model.seller_version'].id)
      end
    end
  end

  def create
    run Sellers::SellerVersion::Create do |result|
      return redirect_to sellers_application_path(result['model.seller_version'].id)
    end

    redirect_to new_sellers_application_path
  end

  def submit
    @operation = run Sellers::SellerVersion::Submit::Present
  end

  def do_submit
    @operation = run Sellers::SellerVersion::Submit do |result|
      return redirect_to sellers_dashboard_path
    end

    render :submit
  end

  private

  attr_reader :operation
  helper_method :operation

  def steps
    Sellers::Applications::StepsController.steps(seller_version)
  end
  helper_method :steps

  def presenter
    @presenter ||= Sellers::Applications::DashboardPresenter.new(
      seller_version,
      steps,
    )
  end
  helper_method :presenter

  def submit_form
    @operation ||= run(Sellers::SellerVersion::Submit::Present)
  end
  helper_method :submit_form

  def assert_application_presence!
    raise NotFound if seller_version.blank?
  end
end

class Sellers::Applications::ProductsController < Sellers::Applications::BaseController
  layout '../sellers/applications/shared/_layout'
  before_action :ensure_cloud_services_provided!
  helper Sellers::ApplicationsHelper

  def index
  end

  def new
    @operation = run Sellers::SellerVersion::Products::Create do |result|
      return redirect_to sellers_application_product_path(result[:application_model], result[:product_model])
    end
  end

  def edit
    @operation = run Sellers::SellerVersion::Products::Update::Present
  end

  def update
    params[:seller_application] ||= {}

    @operation = run Sellers::SellerVersion::Products::Update do |result|
      flash.notice = I18n.t('sellers.applications.messages.changes_saved')
      return redirect_to sellers_application_product_path(result['model.application'], result['model.product'])
    end

    render :edit
  end

  def clone
    @operation = run Sellers::SellerVersion::Products::Clone do |result|
      flash.notice = I18n.t('sellers.applications.messages.product_cloned')
    end

    redirect_to sellers_application_products_path(application)
  end

  def destroy
    if product.destroy
      flash.notice = I18n.t('sellers.applications.messages.product_destroyed')
    end
    redirect_to sellers_application_products_path(application)
  end

  def self.contracts
    [
      Products::AvailabilitySupportForm,
      Products::BackupRecoveryForm,
      Products::BasicsForm,
      Products::CommercialsForm,
      Products::DataProtectionForm,
      Products::EnvironmentForm,
      Products::IdentityAuthenticationForm,
      Products::LocationsForm,
      Products::OnboardingOffboardingForm,
      Products::OperationalSecurityForm,
      Products::ReportingAnalyticsForm,
      Products::SecurityPracticesForm,
      Products::SecurityStandardsForm,
      Products::TermsForm,
      Products::TypeForm,
      Products::UserDataForm,
      Products::UserSeparationForm,
    ]
  end

  def self.steps
    contracts.map do |contract|
      Sellers::Applications::ProductStepPresenter.new(contract)
    end
  end

  private

  def _run_options(options)
    if ['edit', 'update'].include?(action_name)
      options = options.merge(
        'config.contract_class' => contract_class,
      )
    end

    options.merge(
      'config.current_user' => current_user,
    )
  end

  def step
    self.class.steps.find { |step| step.slug == params[:step] } || raise(NotFound)
  end
  helper_method :step

  def contract_class
    step.contract_class if step.present?
  end

  def application
    @application ||= current_user.seller_versions.created.find(params[:application_id])
  end
  helper_method :application

  def products
    application.seller.products.order('name ASC')
  end
  helper_method :products

  def product
    @product ||= products.find(params[:id])
  end
  helper_method :product

  def progress_report
    @progress_report ||= SellerApplicationProgressReport.new(
      application: application,
      product_steps: self.class.steps,
      validate_optional_steps: true,
    )
  end
  helper_method :progress_report

  def presenter
    @presenter ||= Sellers::Applications::ProductDashboardPresenter.new(
      application, product, self.class.steps,
    )
  end
  helper_method :presenter

  attr_reader :operation
  helper_method :operation

  def form
    operation["contract.default"]
  end
  helper_method :form

  def ensure_cloud_services_provided!
    unless application.services.include?('cloud-services')
      redirect_to sellers_application_path(application)
    end
  end
end

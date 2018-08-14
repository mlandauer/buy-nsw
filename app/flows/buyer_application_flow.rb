class BuyerApplicationFlow
  def initialize(application)
    @application = application
  end

  def steps
    [].tap do |steps|
      steps << BuyerApplications::BasicDetailsForm
      steps << BuyerApplications::EmailApprovalForm
      steps << BuyerApplications::EmploymentStatusForm

      if application.reload.requires_manager_approval?
        steps << BuyerApplications::ManagerApprovalForm
      end
    end
  end

  def valid?
    steps.map {|step|
      step.new(application)
    }.reject(&:valid?).empty?
  end

private
  attr_reader :application
end

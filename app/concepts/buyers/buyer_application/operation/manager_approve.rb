# rubocop:disable Airbnb/ClassOrModuleDeclaredInWrongFile
class Buyers::BuyerApplication::ManagerApprove < Trailblazer::Operation
  step Rescue {
    step :model!
  }
  step :set_approval_flag!
  step :advance_application_state!
  step :persist!
  step :log_event!

  def model!(options, params:, **)
    options[:model] = BuyerApplication.awaiting_manager_approval.find_by!(
      id: params[:id],
      manager_approval_token: params[:token],
    )
  end

  def set_approval_flag!(options, **)
    options[:model].manager_approved_at = Time.now
    options[:model].manager_approval_token = nil
    options['result.approved'] = true
  end

  def advance_application_state!(options, **)
    options[:model].manager_approve
  end

  def persist!(options, **)
    options[:model].save
  end

  def log_event!(options, **)
    Event::ManagerApproved.create(
      # The manager did something but they are not a user on the system
      user: nil,
      eventable: options[:model],
      name: options[:model].manager_name,
      email: options[:model].manager_email
    )
  end
end
# rubocop:enable Airbnb/ClassOrModuleDeclaredInWrongFile

class Buyers::BuyerApplication::Create < Trailblazer::Operation
  step :model!
  step :check_application_state!
  step :persist!
  step :log_event!

  def model!(options, **)
    options[:application_model] = options['current_user'].buyer ||
                                    BuyerApplication.new(started_at: Time.now, user: options['current_user'])
  end

  def check_application_state!(options, **)
    options[:application_model].created?
  end

  def persist!(options, **)
    options[:application_model].save!
  end

  def log_event!(options, **)
    Event::StartedApplication.create(
      user: options['current_user'],
      eventable: options[:application_model]
    )
  end
end

module Buyers::ApplicationsHelper
  def change_link(step)
    link_to('Change',
            buyers_application_step_path(application, step),
            class: 'change-link',
            title: 'Change this answer',)
  end
end

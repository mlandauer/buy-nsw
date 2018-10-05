class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  layout 'admin'

  private

  def authenticate_admin!
    if !(current_user && current_user.is_admin?)
      raise NotAuthorized
    end
  end

  def set_content_disposition
    response.headers['Content-Disposition'] = "attachment; filename=#{csv_filename}"
  end
end

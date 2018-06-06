module ApplicationHelper
  include Forms::DateHelper
  include Forms::DocumentHelper
  include Forms::ErrorHelper
  include Forms::LabelHelper
  include Layout::BreadcrumbsHelper

  def deployment_env
    if Rails.env.development?
      'development'
    else
      ENV['DEPLOYMENT_ENVIRONMENT']
    end
  end

  # Super crude way of doing a feature flag
  # This allows buyer registration but hides other parts of the buyer pathway
  def feature_flag_hide_buyer_pathway
    ENV['FEATURE_FLAG_HIDE_BUYER_PATHWAY'].present?
  end

  def title
    if show_development_info
      "(#{deployment_env.try(:titleize)}) buy.nsw"
    else
      "buy.nsw"
    end
  end

  def show_development_info
    # Only show which build we're on and the environment when we're not in production
    deployment_env != 'production'
  end
end

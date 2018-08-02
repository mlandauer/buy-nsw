module Admin::BuyersHelper
  include Admin::DetailHelper

  # NOTE: Some of the details displayed here are the same as those in the buyer
  # application screens
  #
  include Admin::BuyerApplications::DetailHelper
end

module Admin::BuyerApplications::DetailHelper
  def display_buyer_list(type:, resource:)
    display_list(
      fields: buyer_fields,
      resource_name: :buyer_applications,
      type: type,
      resource: resource,
    )
  end

  def buyer_fields
    {
      basic: [
        :name,
        :organisation,
        :cloud_purchase,
        :contactable,
        :contact_number,
        :employment_status,
      ],
      application: [
        :application_body,
      ],
      manager: [
        :manager_name,
        :manager_email,
      ],
    }
  end
end

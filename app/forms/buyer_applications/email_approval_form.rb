module BuyerApplications
  class EmailApprovalForm < BaseForm
    property :application_body
    property :cloud_purchase
    property :contactable
    property :contact_number

    validation :default do

      required(:application_body).filled
      required(:cloud_purchase, in_list?: BuyerApplication.cloud_purchase.options).filled
      required(:contactable, in_list?: BuyerApplication.contactable.options).filled

    end
  end
end

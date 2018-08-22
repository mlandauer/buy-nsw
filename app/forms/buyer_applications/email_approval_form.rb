module BuyerApplications
  class EmailApprovalForm < BaseForm
    property :application_body
    property :cloud_purchase
    property :contactable
    property :contact_number

    validation :default do

      byebug
      required(:application_body).filled
      required(:cloud_purchase, in_list?: BuyerApplication.cloud_purchase.options).filled
      required(:contactable, in_list?: BuyerApplication.contactable.options).filled


      #rule(contactable: [:contactable]) do |contactable|
        #abn.filled? > abn.abn?
      #end
    end
  end
end

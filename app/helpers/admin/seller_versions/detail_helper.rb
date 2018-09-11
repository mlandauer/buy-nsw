module Admin::SellerVersions::DetailHelper
  include Sellers::ProfilesHelper
  def Sellers::ProfilesHelper; end

  def display_seller_list(type:, resource:)
    display_list(
      fields: seller_fields,
      resource_name: :seller_versions,
      type: type,
      resource: resource,
    )
  end

  def seller_fields
    {
      basic: [
        :name,
        :abn,
        :summary,
        :website_url,
        :linkedin_url
      ],
      industry: [
        :services,
        :govdc,
      ],
      contacts: [
        :contact_name,
        :contact_email,
        :contact_phone,
        :representative_name,
        :representative_email,
        :representative_phone
      ],
      disclosures: [
        :investigations,
        :investigations_details,
        :legal_proceedings,
        :legal_proceedings_details,
        :insurance_claims,
        :insurance_claims_details,
        :conflicts_of_interest,
        :conflicts_of_interest_details,
        :other_circumstances,
        :other_circumstances_details,
      ],
      details: [
        :number_of_employees_text,
        :start_up,
        :sme,
        :not_for_profit,
        :australian_owned,
        :regional,
        :indigenous,
        :disability,
        :female_owned,
        :corporate_structure_text,
      ],
      terms: [
        :agree,
        :agreed_at,
        :agreed_by_email,
      ]
    }
  end

end

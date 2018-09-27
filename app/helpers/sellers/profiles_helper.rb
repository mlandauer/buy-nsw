module Sellers::ProfilesHelper
  def seller_profile_tags(seller_version)
    content_tag(:ul, class: 'tags') do
      [:start_up, :sme, :indigenous, :not_for_profit, :govdc, :regional].select do |tag|
        seller_version.public_send(tag) == true
      end.map do |tag|
        content_tag(:li, I18n.t("sellers.tags.#{tag}"), class: "tag-#{tag.to_s.dasherize}")
      end.join(' ').html_safe
    end.html_safe
  end

  def abn_lookup_url(abn)
    "https://abr.business.gov.au/SearchByAbn.aspx?SearchText=#{URI.encode(formatted_abn(abn))}"
  end

  def formatted_abn(abn)
    abn = (abn || '').gsub(' ', '')

    abn = abn.insert(2, ' ') if abn.length > 2
    abn = abn.insert(6, ' ') if abn.length > 6
    abn = abn.insert(10, ' ') if abn.length > 10

    abn
  end

  def government_experience_values(seller)
    labels = []
    keys = [
      :no_experience,
      :local_government_experience,
      :state_government_experience,
      :federal_government_experience,
      :international_government_experience,
    ]
    i18n_base = 'admin.seller_versions.fields.government_experience.values'

    keys.each do |key|
      labels << t("#{i18n_base}.#{key}") if seller.public_send("#{key}")
    end

    labels.join('<br>').html_safe
  end

  def government_experience_values_changed?(seller)
    keys = [
      :no_experience,
      :local_government_experience,
      :state_government_experience,
      :federal_government_experience,
      :international_government_experience,
    ]
    (seller.changed_fields_unreviewed & keys).any?
  end
end

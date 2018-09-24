module Admin::DetailHelper
  def display_list(fields:, type:, resource:, resource_name:, field_classes: {})
    content_tag(:dl, id: type) {
      fields[type].map {|field|
        [
          content_tag(:dt, display_label_for(resource_name, type, field), :class => field_classes[field]) +
          content_tag(:dd, display_value_for(resource, field), :class => field_classes[field])
        ]
      }.flatten.join.html_safe
    }
  end

  def display_label_for(resource_name, type, field)
    t("admin.#{resource_name}.fields.#{field}.name", default: field)
  end

  def display_value_for(resource, field)
    value = resource.public_send(field)

    value = 'yes' if value.is_a?(TrueClass)
    value = 'no' if value.is_a?(FalseClass)
    value = value.text if value.is_a?(Enumerize::Value)
    value = extract_enumerize_set(value) if value.is_a?(Enumerize::Set)
    value = format_timestamp(value) if value.is_a?(Time)

    value = html_escape(value)

    if value.present?
      case field
      when :abn then
        link_to(formatted_abn(value), abn_lookup_url(value))
      when :linkedin_url, :website_url then link_to(value, value)
      else
        value
      end
    else
      content_tag :em, 'blank'
    end
  end

  def extract_enumerize_set(set)
    set.map {|key| key.text }.join('<br>').html_safe
  end

  def format_timestamp(time)
    time.localtime.strftime('%d %b %Y %H:%m')
  end
end

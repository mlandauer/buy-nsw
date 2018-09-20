module Admin::NavigationHelper
  def nav_link_to(label, url, icon: nil, match_prefix: false, short_label: nil)
    if match_prefix
      selected = current_page_or_prefix?(url)
    else
      selected = current_page?(url)
    end

    selected_class = selected ? 'selected' : ''
    icon_class = icon.present? ? "oi oi-#{icon}" : ''

    content_tag(:li, class: selected_class) do
      link_to(url) do
        content_tag(:span, nil, class: icon_class, aria: { hidden: true }) +
        content_tag(:span, label, class: :fullsize) +
        content_tag(:span, short_label, class: :short)
      end
    end
  end

  def current_page_or_prefix?(url)
    pattern = /^#{Regexp.escape(url)}/
    current_page?(url) || request.fullpath =~ pattern
  end
end

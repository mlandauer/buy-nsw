module Admin::FiltersHelper
  def prepare_filter_options(resource_name, key, options)
    empty_value = [""]

    options = options.map do |option|
      if option.is_a?(Array)
        option
      else
        [t("admin.#{resource_name}.search.filters.#{key}.options.#{option}"), option]
      end
    end

    empty_value + options
  end

  def reset_filters_path(search)
    '?skip_filters=1'
  end
end

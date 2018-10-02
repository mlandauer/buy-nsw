module Products
  class ReportingAnalyticsForm < BaseForm
    property :metrics_contents
    property :metrics_channel_types
    property :metrics_channel_other

    property :outage_channel_types
    property :outage_channel_other

    property :usage_channel_types
    property :usage_channel_other

    validation :default, inherit: true do
      required(:metrics_contents).filled(:str?, max_word_count?: 200)
      required(:metrics_channel_types).
        filled(any_checked?: true, one_of?: Product.metrics_channel_types.values)
      required(:metrics_channel_other).maybe(:str?)

      rule(metrics_channel_other: [
        :metrics_channel_types, :metrics_channel_other,
      ]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:outage_channel_types).
        filled(any_checked?: true, one_of?: Product.outage_channel_types.values)
      required(:outage_channel_other).maybe(:str?)

      rule(outage_channel_other: [
        :outage_channel_types, :outage_channel_other,
      ]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:usage_channel_types).
        filled(any_checked?: true, one_of?: Product.usage_channel_types.values)
      required(:usage_channel_other).maybe(:str?)

      rule(usage_channel_other: [
        :usage_channel_types, :usage_channel_other,
      ]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end
    end
  end
end

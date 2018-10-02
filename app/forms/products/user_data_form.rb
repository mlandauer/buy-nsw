module Products
  class UserDataForm < BaseForm
    property :data_import_formats
    property :data_import_formats_other
    property :data_export_formats
    property :data_export_formats_other

    property :data_access_restrictions
    property :data_access_restrictions_details
    property :audit_information
    property :audit_storage_period
    property :log_storage_period

    property :data_disposal_approach

    validation :default, inherit: true do
      required(:data_import_formats).maybe(one_of?: Product.data_import_formats.values)
      required(:data_import_formats_other).maybe(:str?)

      rule(data_import_formats_other: [
        :data_import_formats, :data_import_formats_other,
      ]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:data_export_formats).maybe(one_of?: Product.data_export_formats.values)
      required(:data_export_formats_other).maybe(:str?)

      rule(data_export_formats_other: [
        :data_export_formats, :data_export_formats_other,
      ]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:data_access_restrictions).filled(:bool?)
      required(:data_access_restrictions_details).maybe(:str?)

      rule(data_access_restrictions_details: [
        :data_access_restrictions, :data_access_restrictions_details,
      ]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:audit_information).filled(:bool?)
      required(:audit_storage_period).filled(:str?)
      required(:log_storage_period).filled(:str?)
      required(:data_disposal_approach).filled(:str?)
    end
  end
end

module Concerns::FormStatus
  extend ActiveSupport::Concern

  def started?(&block)
    out = schema.keys.map do |key|
      value = send(key)

      if value.is_a?(Array)
        value.any? do |item|
          case
          when item.respond_to?(:address) then item.address.present?
          when item.respond_to?(:id) then item.id.present?
          else
            item.present?
          end
        end
      elsif value.is_a?(DocumentUploader)
        value.file.present?
      else
        if block_given?
          yield(key, value)
        else
          value.present? || value == false
        end
      end
    end.compact

    out.any?
  end
end

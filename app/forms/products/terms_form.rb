module Products
  class TermsForm < BaseForm
    property :terms_file
    property :remove_terms

    def started?
      super do |key, value|
        next if key == 'remove_terms'
        value.present?
      end
    end
  end
end

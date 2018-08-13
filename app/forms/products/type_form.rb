module Products
  class TypeForm < BaseForm
    property :section

    validation :default, inherit: true do
      required(:section).filled(in_list?: Product.section.values)
    end
  end
end

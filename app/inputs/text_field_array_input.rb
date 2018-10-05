class TextFieldArrayInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil) # rubocop:
    out = ActiveSupport::SafeBuffer.new

    Array(object.public_send(attribute_name)).each_with_index do |element, index|
      key = "#{attribute_name}_#{index}"

      field = template.content_tag(:li) do
        template.content_tag(:div, class: 'form-group') do
          @builder.label(key, for: key, label: "#{index + 1}.") +
          @builder.text_field(
            attribute_name,
            input_html_options.merge(
              name: "#{@builder.object_name}[#{attribute_name}][]",
              value: element,
              id: key,
              class: 'form-control',
            )
          )
        end
      end

      out << field
    end

    template.content_tag(:ol) do
      out
    end
  end

  def input_type
    :text
  end
end

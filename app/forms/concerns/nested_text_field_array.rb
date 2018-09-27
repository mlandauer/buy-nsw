module Concerns::NestedTextFieldArray
  TextFieldArrayPrepopulator = ->(context, name:, limit:) {
    context.send("#{name}=", []) unless context.send(name).is_a?(Array)

    count = 0
    while context.send(name).size < 10 && count < 2
      context.send(name).push('')
      count += 1
    end
  }

  def filter_blank_array_values(array)
    Array(array).reject do |row|
      row.gsub(/\s/, '').blank?
    end
  end
end

class FormErrorDecorator < BaseDecorator
  def messages
    friendly_format_messages(super)
  end

  def [](name)
    messages[name] || []
  end

  private

  def friendly_format_messages(messages)
    tuples = messages.map do |key, messages|
      formatted = messages.yield_self(&method(:remove_blank_messages)).
        yield_self(&method(:downcase_other_messages)).
        yield_self(&method(:limit_politeness))
      [key, formatted]
    end
    Hash[tuples]
  end

  def remove_blank_messages(messages)
    messages.reject do |msg|
      msg.blank?
    end
  end

  def downcase_other_messages(messages)
    if messages.size > 1
      messages[1..-1].each(&:downcase!)
    end
    messages
  end

  def limit_politeness(messages)
    if messages.size > 1
      messages[1..-1].each do |msg|
        msg.gsub!(/please/i, '')
      end
    end
    messages
  end
end

class RegexpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.is_a?(Regexp) || Regexp.compile(value)
  rescue RegexpError, TypeError
    record.errors.add(attribute, :not_regexp)
  end
end

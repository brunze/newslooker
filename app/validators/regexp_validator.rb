class RegexpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.is_a?(Regexp) || Regexp.compile(value)
  rescue RegexpError, TypeError
    record.errors.add(attribute, "must be a valid regular expression")
  end
end

class NestedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :blank) and return if value.nil? && !options[:allow_nil]
    record.errors.add(attribute, :invalid) unless value.valid?
  end
end

class NestedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.valid?
      record.errors.add(attribute, :invalid)
    end
  end
end

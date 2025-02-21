module Backend
module Form
class StandardControl < ApplicationComponent
  def initialize(
    attribute_name:, value:,
    namespace: nil, label: nil, label_for: nil, errors: [],
    disabled: false, required: false, wrapper_attributes: {}, **other_attributes
  )
    @attribute_name = attribute_name
    @value = value
    @namespace = Namespace.from(namespace)
    @input_name = @namespace[@attribute_name]
    @label = label
    @label_for = label_for || @input_name.underscore
    @errors = errors
    @disabled = !!disabled
    @required = !!required
    @wrapper_attributes = wrapper_attributes
    @other_attributes = other_attributes
  end
  attr_reader \
    :attribute_name, :value, :namespace,
    :input_name, :label, :label_for, :errors,
    :disabled, :required, :wrapper_attributes, :other_attributes
end
end
end

module Backoffice
module Forms
class SimpleInputControl < StandardControl
  def initialize(input_type:, **kwargs)
    super(**kwargs)
    @input_type = input_type
  end
  attr_reader :input_type

  def content
    tag.input(type: input_type, value:, name: input_name, id: label_for, required:, **other_attributes)
  end
end
end
end

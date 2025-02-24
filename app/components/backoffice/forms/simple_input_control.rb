module Backoffice
module Forms
class SimpleInputControl < StandardControl
  def content
    tag.input(type: input_type, value:, name: input_name, id: label_for, required:, **other_attributes)
  end

  private

  def input_type
    raise NotImplementedError
  end
end
end
end

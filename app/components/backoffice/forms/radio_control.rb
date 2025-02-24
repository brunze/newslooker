module Backoffice
module Forms
class RadioControl < StandardControl
  def initialize(options:, **kwargs)
    super(**kwargs)
    @options = options
  end
  attr_reader :options, :required

  def checked?(current_value)
    current_value == value
  end

  def content
    Tilt.new(__dir__ + "/radio_control_content.html.slim").render(self).html_safe
  end
end
end
end

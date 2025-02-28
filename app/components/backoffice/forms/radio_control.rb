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
    render_slim_template(__dir__ + "/radio_control_content")
  end
end
end
end

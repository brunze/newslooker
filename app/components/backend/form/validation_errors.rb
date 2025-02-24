module Backend
module Form
class ValidationErrors < ApplicationComponent
  def initialize(messages:)
    @messages = messages || []
  end
  attr_reader :messages
end
end
end

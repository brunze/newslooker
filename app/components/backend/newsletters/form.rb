module Backend
module Newsletters
class Form < ViewComponent::Base
  def initialize(newsletter: nil)
    @newsletter = newsletter || ::Newsletter.new
  end
  attr_reader :newsletter

  def newsletter_fields
    Fields.new(newsletter:, namespace: ::Backend::Form::Namespace[[ "newsletter" ]])
  end
end
end
end

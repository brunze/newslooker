module Backoffice
module Newsletters
class Form < ApplicationComponent
  def initialize(newsletter: nil)
    @newsletter = newsletter || ::Newsletter.new
  end
  attr_reader :newsletter

  def newsletter_fields
    Fields.new(newsletter:, namespace: ::Backoffice::Forms::Namespace[[ "newsletter" ]])
  end
end
end
end

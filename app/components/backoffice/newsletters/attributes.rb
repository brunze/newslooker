module Backoffice
module Newsletters
class Attributes < ApplicationComponent
  def initialize(newsletter:)
    @newsletter = newsletter
  end
  attr_reader :newsletter
end
end
end

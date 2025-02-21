module Backend
module Newsletters
module Pages
class Show < ApplicationComponent
  def initialize(newsletter:)
    @newsletter = newsletter
  end
  attr_reader :newsletter
end
end
end
end

module Backoffice
module Issues
class Attributes < ApplicationComponent
  def initialize(issue:)
    @issue = issue
  end
  attr_reader :issue
end
end
end

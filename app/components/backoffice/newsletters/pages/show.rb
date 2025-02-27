module Backoffice
module Newsletters
module Pages
class Show < ::Backoffice::Page
  def initialize(newsletter:)
    @newsletter = newsletter
  end
  attr_reader :newsletter

  private

  def page_class =  "NewsletterShowPage"
end
end
end
end

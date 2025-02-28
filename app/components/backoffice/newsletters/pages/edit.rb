module Backoffice
module Newsletters
module Pages
class Edit < Page
  def initialize(newsletter:)
    @newsletter = newsletter
  end
  attr_reader :newsletter

  private

  def page_class = "NewsletterEditPage"

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 newsletter.name
      end
      render newsletter_form
    end
  end

  def newsletter_form
    Form.new(newsletter:)
  end
end
end
end
end

module Backoffice
module Newsletters
module Pages
class New < Page
  def initialize(newsletter: nil)
    @newsletter = newsletter || ::Newsletter.new
  end
  attr_reader :newsletter

  private

  def page_class = "NewsletterNewPage"

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 t(".add_newsletter")
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

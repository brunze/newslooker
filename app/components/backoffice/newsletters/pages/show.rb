module Backoffice
module Newsletters
module Pages
class Show < Page
  def initialize(newsletter:)
    @newsletter = newsletter
  end
  attr_reader :newsletter

  private

  def page_class =  "NewsletterShowPage"

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 newsletter.name
      end
      surface.with_header_extras do
        link_to(t("edit"), edit_newsletter_path(newsletter), class: "btn") +
        button_to(t(".crawl_newsletter"), crawl_newsletter_path)
      end
      render newsletter_attributes
    end
  end

  def newsletter_attributes
    Backoffice::Newsletters::Attributes.new(newsletter:)
  end
end
end
end
end

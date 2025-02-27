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

  def top_nav_options
    super.deep_merge({ current: :newsletters })
  end

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 newsletter.name
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

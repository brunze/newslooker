module Backoffice
module Newsletters
module Pages
class Index < Page
  def initialize(newsletters: nil)
    @newsletters = newsletters || []
  end
  attr_reader :newsletters

  private

  def page_class =  "NewsletterIndexPage"

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 Newsletter.model_name.human.pluralize
      end
      surface.with_header_extras do
        link_to t("add"), new_newsletter_path, class: "btn"
      end
      render_newsletters_list
    end
  end

  def render_newsletters_list
    if newsletters.any?
      render_slim <<~SLIM
        ul
          - newsletters.each do |newsletter|
            li = link_to newsletter.name, newsletter_path(newsletter)
      SLIM
    end
  end
end
end
end
end

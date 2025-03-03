module Backoffice
module Links
module Pages
class Index < ::Backoffice::Page
  def initialize(links: nil, next_page_url: nil)
    @links = links || []
    @next_page_url = next_page_url
  end
  attr_reader :links, :next_page_url

  private

  def page_class =  "LinkIndexPage"

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 Link.model_name.human.pluralize
      end
      render_links_list
    end
  end

  def render_links_list
    if links.any?
      render_slim <<~SLIM
        #links-list
          = render ::Backoffice::Links::List.new(links:)
        #load-more-links-button
          - if next_page_url
            a.btn href=next_page_url hx-boost="false" script=load_more_links_script
              = t("load_more")
      SLIM
    end
  end

  def load_more_links_script
    <<~HYPERSCRIPT
      on click
        halt the event
        fetch `${@href}` as html
          put the <#links-list .StandardLink/> in it at the end of <#links-list .LinkList/>
          put <#load-more-links-button */> in it into <#load-more-links-button/>
    HYPERSCRIPT
  end
end
end
end
end

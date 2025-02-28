module Backoffice
module Newsletters
module Pages
class Page < ::Backoffice::Page
  private

  def page_classes
    [ *super, "NewsletterPage" ]
  end

  def top_nav_options
    super.deep_merge({ current: :newsletters })
  end
end
end
end
end

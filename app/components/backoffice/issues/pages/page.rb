module Backoffice
module Issues
module Pages
class Page < ::Backoffice::Page
  private

  def page_classes
    [ *super, "IssuePage" ]
  end

  def top_nav_options
    super.deep_merge({ current: :issues })
  end
end
end
end
end

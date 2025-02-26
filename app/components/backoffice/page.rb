module Backoffice
  class Page < ApplicationComponent
    renders_one :main_content

    slim_template <<~SLIM
      div(class=page_classes)
        = render top_nav
        main
          = main_content
    SLIM

    private

    def top_nav
      TopNav.new(**top_nav_options)
    end

    def top_nav_options
      {}
    end

    def page_classes
      [ "BackofficePage", self.class.name.demodulize ]
    end
  end
end

module Backoffice
  class Page < ApplicationComponent
    renders_one :main_content

    slim_template <<~SLIM
      div(class=page_classes)
        header
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
      [ "BackofficePage", page_class ].compact
    end

    def page_class
      nil
    end
  end
end

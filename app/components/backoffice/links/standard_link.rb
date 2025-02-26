module Backoffice
module Links
  class StandardLink < ApplicationComponent
    def initialize(link:)
      @link = link
    end
    attr_reader :link

    slim_template <<~SLIM
      .StandardLink
        a href=link.url target="_blank" = link.text
        p.issue = link.issue.title
        p.blurb = link.blurb
    SLIM
  end
end
end

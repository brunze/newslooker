module Backoffice
module Links
  class StandardLink < ApplicationComponent
    def initialize(link:, hide: [])
      @link = link
      @hide_issue = hide.include?(:issue)
      @hide_blurb = hide.include?(:blurb)
    end
    attr_reader :link, :hide_issue, :hide_blurb

    slim_template <<~SLIM
      .StandardLink
        a href=link.url target="_blank" = link.text
        - unless hide_issue
          p.issue = link.issue.title
        - unless hide_blurb
          p.blurb = link.blurb
    SLIM
  end
end
end

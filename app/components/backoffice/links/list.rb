module Backoffice
module Links
  class List < ApplicationComponent
    def initialize(links:, empty_state_message: nil, **standard_link_kwargs)
      @links = links || []
      @empty_state_message = empty_state_message.blank? ? nil : empty_state_message
      @standard_link_kwargs = standard_link_kwargs
    end
    attr_reader :links, :empty_state_message, :standard_link_kwargs

    renders_one :empty_state_content

    slim_template <<~SLIM
      .LinkList
        - if links.any?
          - links.each do |link|
            = render ::Backoffice::Links::StandardLink.new(link:, **standard_link_kwargs)
        - else
          .empty-state
            - if empty_state_content?
              = empty_state_content
            - else
              .empty-state
                = empty_state_message || t(".no_links")
    SLIM
  end
end
end

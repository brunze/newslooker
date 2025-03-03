module Backoffice
  class HeroSearch < ApplicationComponent
    def initialize(needle: nil)
      @needle = needle
    end
    attr_reader :needle

    slim_template <<~SLIM
      section.HeroSearch
        h1 = t(".search_cta")
        form action=search_path
          input(
            type="search" name="q" value=needle placeholder=random_placeholder required
            autocomplete="off" autofocus=true script="init select() me end on focus select() me"
          )
    SLIM

    private

    def random_placeholder
      t(".placeholders").sample
    end
  end
end

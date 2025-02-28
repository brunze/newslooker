module Backoffice
  class TopNav < ApplicationComponent
    def initialize(current: nil)
      @current = current&.to_sym
    end
    attr_reader :current

    def links
      [
        Link.new("/",            t(".home"),        current == :home),
        Link.new("/newsletters", t(".newsletters"), current == :newsletters),
        Link.new("/issues",      t(".issues"),      current == :issues)
      ]
    end

    Link = Data.define(:href, :label, :current)
  end
end

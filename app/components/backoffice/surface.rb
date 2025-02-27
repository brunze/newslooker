module Backoffice
  class Surface < ApplicationComponent
    def initialize(classes: nil)
      @classes = classes || []
    end
    attr_reader :classes

    renders_one :heading
    renders_one :header_extras

    slim_template <<~SLIM
      section.Surface class=classes
        header
          .heading = heading
          .extras = header_extras
        .content
          = content
    SLIM
  end
end

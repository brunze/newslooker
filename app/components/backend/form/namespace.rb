module Backend
module Form
Namespace = Data.define(:segments) do
  def initialize(segments: [])
    super(
      segments: segments.map do
        it.to_s.downcase.tr_s("^a-z0-9", " ").strip.tr(" ", "_")
      end
    )
  end

  def [](segment = "")
    self.with(segments: segments + [ segment ])
  end

  def to_s
    case segments
    in [] then ""
    in [single_segment] then single_segment.to_s
    in [first_segment, *rest] then "#{first_segment}[#{rest.join("][")}]"
    end
  end

  def underscore
    segments.join("_")
  end

  def self.from(*things)
    case things
    in [Namespace => namespace] then namespace
    in [], [nil] then Namespace.new
    else Namespace.new(things)
    end
  end
end
end
end

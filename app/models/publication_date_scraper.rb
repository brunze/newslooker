module PublicationDateScraper
  def self.make(attributes)
    case attributes.with_indifferent_access.fetch(:kind).to_s
    in "NodeAttributePublicationDateScraper" then NodeAttributePublicationDateScraper.new(attributes)
    in "NodeTextPublicationDateScraper" then NodeTextPublicationDateScraper.new(attributes)
    end
  end

  class ActiveRecordType < ActiveRecord::Type::Json
    def cast(value)
      case value
      when NilClass then nil
      when
        NodeTextPublicationDateScraper,
        NodeAttributePublicationDateScraper
        value
      else PublicationDateScraper.make(value)
      end
    end

    def deserialize(value)
      cast(super(value))
    end
  end

  def self.type
    ActiveRecordType.new
  end
end

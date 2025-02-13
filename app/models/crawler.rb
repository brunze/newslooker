class Crawler
  def self.make(attributes)
    case attributes.with_indifferent_access.fetch(:kind).to_s
    in "URLTemplateCrawler" then URLTemplateCrawler.new(attributes)
    in "ArchivePageCrawler" then ArchivePageCrawler.new(attributes)
    end
  end

  private

  def default_crawl_limits
    { issue_numbers: { from: 1, to: Float::INFINITY } }
  end
end

class Crawler::ActiveRecordType < ActiveRecord::Type::Json
  def cast(value)
    case value
    when NilClass then nil
    when Crawler then value
    else Crawler.make(value)
    end
  end

  def deserialize(value)
    cast(super(value))
  end

  def serialize(value)
    super(value.attributes)
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:scraper, Scraper::ActiveRecordType)
  ActiveModel::Type.register(:scraper, Scraper::ActiveRecordType)
  ActiveRecord::Type.register(:crawler, Crawler::ActiveRecordType)
  ActiveModel::Type.register(:crawler, Crawler::ActiveRecordType)
end

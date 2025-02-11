ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:scraper_config, ScraperConfig::ActiveRecordType)
  ActiveModel::Type.register(:scraper_config, ScraperConfig::ActiveRecordType)
end

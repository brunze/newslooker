class HTTPURLValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /\Ahttps?:\/\/.*\z/.match?(value)
      record.errors.add(attribute, :not_http_url)
    end
  end
end

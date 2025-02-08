class HTTPURLValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /\Ahttps?:\/\/.*\z/.match?(value)
      record.errors.add(attribute, "must be a HTTP(S) URL")
    end
  end
end

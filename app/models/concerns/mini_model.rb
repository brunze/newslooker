module MiniModel
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model
    include ActiveModel::Attributes

    delegate :hash, :as_json, to: :attributes
  end

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def inspect
    "#<#{self.class} #{as_json}>"
  end
end

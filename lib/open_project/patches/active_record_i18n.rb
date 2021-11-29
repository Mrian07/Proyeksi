

module ActiveRecord
  class Base
    include Redmine::I18n

    def self.human_attribute_name(attr, options = {})
      attr = attr.to_s.gsub(/_id\z/, '')
      super
    end
  end
end

#-- encoding: UTF-8

module Queries::Operators
  class Base
    class_attribute :label_key,
                    :symbol,
                    :value_required

    self.value_required = true

    def self.label(label)
      self.label_key = "label_#{label}"
    end

    def self.set_symbol(sym)
      self.symbol = sym
    end

    def self.require_value(value)
      self.value_required = value
    end

    def self.requires_value?
      value_required
    end

    def self.sql_for_field(_values, _db_table, _db_field)
      raise NotImplementedError
    end

    def self.connection
      ActiveRecord::Base.connection
    end

    def self.to_sym
      symbol.to_sym
    end

    def self.human_name
      I18n.t(label_key)
    end

    def self.to_query
      CGI.escape(symbol.to_s)
    end
  end
end

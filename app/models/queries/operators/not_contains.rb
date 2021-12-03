#-- encoding: UTF-8

module Queries::Operators
  class NotContains < Base
    include Concerns::ContainsAllValues

    label 'not_contains'
    set_symbol '!~'

    def self.sql_for_field(values, db_table, db_field)
      "NOT (#{super}) OR #{db_table}.#{db_field} IS NULL"
    end
  end
end

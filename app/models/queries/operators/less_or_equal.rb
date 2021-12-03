#-- encoding: UTF-8

module Queries::Operators
  class LessOrEqual < Base
    label 'less_or_equal'
    set_symbol '<='

    def self.sql_for_field(values, db_table, db_field)
      "#{db_table}.#{db_field} <= #{values.first.to_f}"
    end
  end
end

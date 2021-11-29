#-- encoding: UTF-8



module Queries::Operators
  class CastedGreaterOrEqual < Base
    label 'greater_or_equal'
    set_symbol '>='

    def self.sql_for_field(values, db_table, db_field)
      "#{db_table}.#{db_field} != '' " +
        "AND CAST(#{db_table}.#{db_field} AS decimal(60,4)) >= #{values.first.to_f}"
    end
  end
end

#-- encoding: UTF-8

module Queries::Operators
  class Today < Base
    label 'today'
    set_symbol 't'
    require_value false

    extend DateRangeClauses

    def self.sql_for_field(_values, db_table, db_field)
      relative_date_range_clause(db_table, db_field, 0, 0)
    end
  end
end

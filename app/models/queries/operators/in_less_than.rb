#-- encoding: UTF-8



module Queries::Operators
  class InLessThan < Base
    label 'in_less_than'
    set_symbol '<t+'

    extend DateRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      relative_date_range_clause(db_table, db_field, 0, values.first.to_i)
    end
  end
end

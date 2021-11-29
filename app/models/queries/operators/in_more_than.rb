#-- encoding: UTF-8



module Queries::Operators
  class InMoreThan < Base
    label 'in_more_than'
    set_symbol '>t+'

    extend DateRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      relative_date_range_clause(db_table, db_field, values.first.to_i, nil)
    end
  end
end

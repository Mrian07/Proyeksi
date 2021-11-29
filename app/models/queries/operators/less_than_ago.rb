#-- encoding: UTF-8



module Queries::Operators
  class LessThanAgo < Base
    label 'less_than_ago'
    set_symbol '>t-'

    extend DateRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      relative_date_range_clause(db_table, db_field, - values.first.to_i, 0)
    end
  end
end

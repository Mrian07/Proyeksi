#-- encoding: UTF-8

module Queries::Operators
  class BetweenDate < Base
    label 'between'
    set_symbol '<>d'

    extend DateRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      lower_boundary, upper_boundary = values.map { |v| v.blank? ? nil : Date.parse(v) }

      date_range_clause(db_table, db_field, lower_boundary, upper_boundary)
    end
  end
end

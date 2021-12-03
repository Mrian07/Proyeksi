#-- encoding: UTF-8

module Queries::Operators
  class BetweenDateTime < Base
    label 'between'
    set_symbol '<>d'

    extend DatetimeRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      lower_boundary, upper_boundary = values.map { |v| v.blank? ? nil : DateTime.parse(v) }

      datetime_range_clause(db_table,
                            db_field,
                            lower_boundary,
                            upper_boundary)
    end
  end
end

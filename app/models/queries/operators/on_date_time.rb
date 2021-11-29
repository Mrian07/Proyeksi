#-- encoding: UTF-8



module Queries::Operators
  class OnDateTime < Base
    label 'on'
    set_symbol '=d'

    extend DatetimeRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      datetime = DateTime.parse(values.first)

      lower_boundary = datetime
      upper_boundary = datetime + 24.hours

      datetime_range_clause(db_table,
                            db_field,
                            lower_boundary,
                            upper_boundary)
    end
  end
end

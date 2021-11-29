#-- encoding: UTF-8



module Queries::Operators
  class OnDate < Base
    label 'on'
    set_symbol '=d'

    extend DateRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      date_range_clause(db_table,
                        db_field,
                        Date.parse(values.first),
                        Date.parse(values.first))
    end
  end
end

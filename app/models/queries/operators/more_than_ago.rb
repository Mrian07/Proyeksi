#-- encoding: UTF-8

module Queries::Operators
  class MoreThanAgo < Base
    label 'more_than_ago'
    set_symbol '<t-'

    extend DateRangeClauses

    def self.sql_for_field(values, db_table, db_field)
      relative_date_range_clause(db_table, db_field, nil, -values.first.to_i)
    end
  end
end

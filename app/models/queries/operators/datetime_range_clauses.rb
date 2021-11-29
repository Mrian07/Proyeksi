#-- encoding: UTF-8



module Queries::Operators
  module DatetimeRangeClauses
    def datetime_range_clause(table, field, from, to)
      s = []
      if from
        s << ("#{table}.#{field} >= '%s'" % [connection.quoted_date(from)])
      end
      if to
        s << ("#{table}.#{field} <= '%s'" % [connection.quoted_date(to)])
      end
      s.join(' AND ')
    end
  end
end

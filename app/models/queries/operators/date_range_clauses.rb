#-- encoding: UTF-8

module Queries::Operators
  module DateRangeClauses
    # Returns a SQL clause for a date or datetime field for a relative range from
    # the end of the day of yesterday + from until the end of today + to.
    def relative_date_range_clause(table, field, from, to)
      if from
        from_date = Date.today + from
      end
      if to
        to_date = Date.today + to
      end
      date_range_clause(table, field, from_date, to_date)
    end

    # Returns a SQL clause for date or datetime field for an exact range starting
    # at the beginning of the day of from until the end of the day of to
    def date_range_clause(table, field, from, to)
      s = []
      if from
        s << "#{table}.#{field} > '%s'" % [quoted_date_from_utc(from.yesterday)]
      end
      if to
        s << "#{table}.#{field} <= '%s'" % [quoted_date_from_utc(to)]
      end
      s.join(' AND ')
    end

    def quoted_date_from_utc(value)
      connection.quoted_date(value.to_time(:utc).end_of_day)
    end
  end
end

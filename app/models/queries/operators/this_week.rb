#-- encoding: UTF-8

module Queries::Operators
  class ThisWeek < Base
    label 'this_week'
    set_symbol 'w'
    require_value false

    def self.sql_for_field(_values, db_table, db_field)
      from = begin_of_week
      "#{db_table}.#{db_field} BETWEEN '%s' AND '%s'" % [
        connection.quoted_date(from), connection.quoted_date(from + 7.days)
      ]
    end

    def self.begin_of_week
      if I18n.t(:general_first_day_of_week) == '7'
        # week starts on sunday
        if Date.today.cwday == 7
          Time.now.at_beginning_of_day
        else
          Time.now.at_beginning_of_week - 1.day
        end
      else
        # week starts on monday (Rails default)
        Time.now.at_beginning_of_week
      end
    end
  end
end

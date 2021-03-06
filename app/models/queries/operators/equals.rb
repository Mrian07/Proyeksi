#-- encoding: UTF-8

module Queries::Operators
  class Equals < Base
    label 'equals'
    set_symbol '='

    def self.sql_for_field(values, db_table, db_field)
      # code expects strings (e.g. for quoting), but ints would work as well: unify them here
      values = values.map(&:to_s)

      sql = ''

      if values.present?
        if values.include?('-1')
          sql = "#{db_table}.#{db_field} IS NULL OR "
        end

        sql += "#{db_table}.#{db_field} IN (" +
          values.map { |val| "'#{connection.quote_string(val)}'" }.join(',') + ')'
      else
        # empty set of allowed values produces no result
        sql = '0=1'
      end

      sql
    end
  end
end

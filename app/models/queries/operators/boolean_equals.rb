#-- encoding: UTF-8



module Queries::Operators
  class BooleanEquals < Base
    label 'equals'
    set_symbol '='

    def self.sql_for_field(values, db_table, db_field)
      sql = ''

      if values.include?('f')
        sql = "#{db_table}.#{db_field} IS NULL OR "
      end

      sql += "#{db_table}.#{db_field} IN (" +
             values.map { |val| "'#{connection.quote_string(val)}'" }.join(',') + ')'

      sql
    end
  end
end

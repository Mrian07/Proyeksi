#-- encoding: UTF-8



module Queries::Operators
  class BooleanEqualsStrict < Base
    label 'equals'
    set_symbol '='

    def self.sql_for_field(values, db_table, db_field)
      "#{db_table}.#{db_field} IN (#{values.map { |val| "'#{connection.quote_string(val)}'" }.join(',')})"
    end
  end
end

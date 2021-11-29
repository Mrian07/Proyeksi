#-- encoding: UTF-8



module Queries::Operators
  class BooleanNotEquals < Base
    label 'not_equals'
    set_symbol '!'

    def self.sql_for_field(values, db_table, db_field)
      if values.length > 1
        raise "Only expected one value here"
      end

      if values.include?('t')
        BooleanEquals.sql_for_field(['f'], db_table, db_field)
      else
        BooleanEquals.sql_for_field(['t'], db_table, db_field)
      end
    end
  end
end

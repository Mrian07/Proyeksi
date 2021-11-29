#-- encoding: UTF-8



module Queries::Operators
  class None < Base
    label 'none'
    set_symbol '!*'
    require_value false

    def self.sql_for_field(_values, db_table, db_field)
      "#{db_table}.#{db_field} IS NULL"
    end
  end
end

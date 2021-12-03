#-- encoding: UTF-8

module Queries::Operators
  class All < Base
    label 'all'
    set_symbol '*'
    require_value false

    def self.sql_for_field(_values, db_table, db_field)
      "#{db_table}.#{db_field} IS NOT NULL"
    end
  end
end

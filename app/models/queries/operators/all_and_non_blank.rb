#-- encoding: UTF-8



module Queries::Operators
  class AllAndNonBlank < All
    def self.sql_for_field(_values, db_table, db_field)
      "#{super} AND #{db_table}.#{db_field} <> ''"
    end
  end
end

#-- encoding: UTF-8



module Queries::Operators
  class NoneOrBlank < None
    def self.sql_for_field(_values, db_table, db_field)
      "#{super} OR #{db_table}.#{db_field} = ''"
    end
  end
end

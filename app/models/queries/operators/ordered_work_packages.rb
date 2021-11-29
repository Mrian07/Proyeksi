#-- encoding: UTF-8



module Queries::Operators
  class OrderedWorkPackages < Base
    label 'open_work_packages'
    set_symbol 'ow'
    require_value false

    def self.sql_for_field(_values, _db_table, _db_field)
      "#{OrderedWorkPackage.table_name}.position IS NOT NULL"
    end
  end
end

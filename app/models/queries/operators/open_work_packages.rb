#-- encoding: UTF-8

module Queries::Operators
  class OpenWorkPackages < Base
    label 'open_work_packages'
    set_symbol 'o'
    require_value false

    def self.sql_for_field(_values, _db_table, _db_field)
      "#{Status.table_name}.is_closed=#{connection.quoted_false}"
    end
  end
end

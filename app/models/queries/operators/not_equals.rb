#-- encoding: UTF-8

module Queries::Operators
  class NotEquals < Base
    label 'not_equals'
    set_symbol '!'

    def self.sql_for_field(values, db_table, db_field)
      # code expects strings (e.g. for quoting), but ints would work as well: unify them here
      values = values.map(&:to_s)

      sql = ''

      if values.present?
        "(#{db_table}.#{db_field} IS NULL OR #{db_table}.#{db_field} NOT IN (" +
          values.map { |val| "'#{connection.quote_string(val)}'" }.join(',') + '))'
      else
        # empty set of forbidden values allows all results
        '1=1'
      end
    end
  end
end

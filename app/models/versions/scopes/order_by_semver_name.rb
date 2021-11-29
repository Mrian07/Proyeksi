#-- encoding: UTF-8



module Versions::Scopes
  module OrderBySemverName
    extend ActiveSupport::Concern

    class_methods do
      def order_by_semver_name
        reorder semver_sql, :name
      end

      # Returns an sql for ordering which:
      # * Returns a substring from the beginning of the name up until the first alphabetical character e.g. "1.2.3 "
      #   from "1.2.3 ABC"
      # * Replaces all non numerical character groups in that substring by a blank, e.g "1.2.3 " to "1 2 3 "
      # * Splits the result into an array of individual number parts, e.g. "{1, 2, 3, ''}" from "1 2 3 "
      # * removes all empty array items, e.g. "{1, 2, 3}" from "{1, 2, 3, ''}"
      def semver_sql(table_name = Version.table_name)
        sql = <<~SQL
          array_remove(regexp_split_to_array(regexp_replace(substring(#{table_name}.name from '^[^a-zA-Z]+'), '\\D+', ' ', 'g'), ' '), '')::int[]
        SQL

        Arel.sql(sql)
      end
    end
  end
end

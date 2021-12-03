#-- encoding: UTF-8

module Queries::Operators::Concerns
  module ContainsAllValues
    extend ActiveSupport::Concern

    class_methods do
      def sql_for_field(values, db_table, db_field)
        values
          .first
          .split(/\s+/)
          .map { |substr| "#{db_table}.#{db_field} ILIKE '%#{connection.quote_string(substr)}%'" }
          .join(' AND ')
      end
    end
  end
end

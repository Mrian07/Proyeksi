#-- encoding: UTF-8



module Principals::Scopes
  module OrderedByName
    extend ActiveSupport::Concern

    class_methods do
      # Returns principals sorted by the name format defined by
      # +Setting.name_format+
      #
      # @desc [Boolean] Whether the sortation should be reversed
      # @return [ActiveRecord::Relation] A scope of sorted principals
      def ordered_by_name(desc: false)
        direction = desc ? 'DESC' : 'ASC'

        order_case = Arel.sql <<~SQL
          CASE
          WHEN users.type = 'User' THEN LOWER(#{user_concat_sql})
          WHEN users.type != 'User' THEN LOWER(users.lastname)
          END #{direction}
        SQL

        order order_case
      end

      private

      def user_concat_sql
        case Setting.user_format
        when :firstname_lastname
          "concat_ws(' ', users.firstname, users.lastname)"
        when :firstname
          'users.firstname'
        when :lastname_firstname, :lastname_coma_firstname
          "concat_ws(' ', users.lastname, users.firstname)"
        when :username
          "users.login"
        else
          raise ArgumentError, "Invalid user format"
        end
      end
    end
  end
end

#-- encoding: UTF-8

module Queries::Filters::Shared::UserNameFilter
  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def type
      :string
    end

    def self.key
      :name
    end

    def where
      case operator
      when '='
        ["#{sql_concat_name} IN (?)", sql_value]
      when '!'
        ["#{sql_concat_name} NOT IN (?)", sql_value]
      when '~'
        ["#{sql_concat_name} LIKE ?", "%#{sql_value}%"]
      when '!~'
        ["#{sql_concat_name} NOT LIKE ?", "%#{sql_value}%"]
      end
    end

    private

    def sql_value
      case operator
      when '=', '!'
        values.map { |val| self.class.connection.quote_string(val.downcase) }.join(',')
      when '~', '!~'
        values.first.downcase
      end
    end

    def sql_concat_name
      case Setting.user_format
      when :firstname_lastname, :lastname_coma_firstname
        "LOWER(CONCAT(users.firstname, CONCAT(' ', users.lastname)))"
      when :firstname
        'LOWER(users.firstname)'
      when :lastname_firstname
        "LOWER(CONCAT(users.lastname, CONCAT(' ', users.firstname)))"
      when :username
        "LOWER(users.login)"
      end
    end
  end

  module ClassMethods
    def key
      :name
    end
  end
end

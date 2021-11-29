#-- encoding: UTF-8



module Queries::Filters::Shared::AnyUserNameAttributeFilter
  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def key
      :any_name_attribute
    end

    def available_operators
      [Queries::Operators::Contains,
       Queries::Operators::NotContains]
    end

    private

    def sql_concat_name
      <<-SQL
    LOWER(
      CONCAT(
        users.firstname, ' ', users.lastname,
        ' ',
        users.lastname, ' ', users.firstname,
        ' ',
        users.login,
        ' ',
        users.mail
      )
    )
      SQL
    end
  end

  module ClassMethods
    def key
      :any_name_attribute
    end
  end
end

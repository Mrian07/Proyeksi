#-- encoding: UTF-8

# Returns principals whose
# * login
# * firstname
# * lastname
# matches the provided string
module Principals::Scopes
  module Like
    extend ActiveSupport::Concern

    class_methods do
      def like(query)
        firstnamelastname = "((firstname || ' ') || lastname)"
        lastnamefirstname = "((lastname || ' ') || firstname)"

        s = "%#{query.to_s.downcase.strip.tr(',', '')}%"

        where(['LOWER(login) LIKE :s OR ' +
                 "LOWER(#{firstnamelastname}) LIKE :s OR " +
                 "LOWER(#{lastnamefirstname}) LIKE :s OR " +
                 'LOWER(mail) LIKE :s',
               { s: s }])
          .order(:type, :login, :lastname, :firstname, :mail)
      end
    end
  end
end

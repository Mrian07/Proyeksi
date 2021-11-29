#-- encoding: UTF-8



# Creates scopes for the :status enums but ensuring that not_builtin is used at the same time
# Excludes
#   * DeletedUser
#   * SystemUser
#   * AnonymousUser
module Principals::Scopes
  module Status
    extend ActiveSupport::Concern

    included do
      statuses.each do |key, val|
        define_singleton_method(key) do
          not_builtin.where(status: val)
        end

        define_singleton_method("not_#{key}") do
          not_builtin.where.not(status: val)
        end
      end
    end
  end
end

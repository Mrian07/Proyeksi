#-- encoding: UTF-8

module Roles
  class SetAttributesService < ::BaseServices::SetAttributes
    def set_default_attributes(*)
      model.permissions = Role.non_member.permissions if model.permissions.nil? || model.permissions.empty?
    end
  end
end

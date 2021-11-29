#-- encoding: UTF-8



module API
  module V3
    module Roles
      class RoleRepresenter < ::API::Decorators::Single
        self_link

        # TODO: This is only a stub
        property :id, render_nil: true
        property :name

        def _type
          'Role'
        end
      end
    end
  end
end

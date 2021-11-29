#-- encoding: UTF-8



module API
  module V3
    module Principals
      module NotBuiltinElements
        extend ::ActiveSupport::Concern

        included do
          collection :elements,
                     getter: ->(*) {
                       represented.map do |model|
                         representer_class = case model
                                             when User
                                               ::API::V3::Users::UserRepresenter
                                             when Group
                                               ::API::V3::Groups::GroupRepresenter
                                             when PlaceholderUser
                                               ::API::V3::PlaceholderUsers::PlaceholderUserRepresenter
                                             else
                                               raise "unsupported type"
                                             end

                         representer_class.new(model, current_user: current_user)
                       end
                     },
                     exec_context: :decorator,
                     embedded: true
        end
      end
    end
  end
end

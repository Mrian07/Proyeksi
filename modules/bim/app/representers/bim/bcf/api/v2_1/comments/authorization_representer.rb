

module Bim::Bcf::API::V2_1
  class Comments::AuthorizationRepresenter < BaseRepresenter
    property :comment_actions,
             getter: ->(decorator:, **) {
               if decorator.manage_bcf_allowed?
                 %w[update]
               else
                 []
               end
             }

    def manage_bcf_allowed?
      represented.user.allowed_to?(:manage_bcf, represented.model.project)
    end
  end
end

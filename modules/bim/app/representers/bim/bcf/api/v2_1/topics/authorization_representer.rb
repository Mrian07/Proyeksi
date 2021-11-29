#-- encoding: UTF-8



module Bim::Bcf::API::V2_1
  class Topics::AuthorizationRepresenter < BaseRepresenter
    property :topic_actions,
             getter: ->(decorator:, **) {
               if decorator.manage_bcf_allowed?
                 %w[update updateRelatedTopics updateFiles createViewpoint]
               else
                 []
               end
             }

    property :topic_status,
             getter: ->(decorator:, **) {
               if decorator.manage_bcf_allowed?
                 assignable_statuses(model.new_record?).pluck(:name)
               else
                 []
               end
             }

    def manage_bcf_allowed?
      represented.user.allowed_to?(:manage_bcf, represented.model.project)
    end
  end
end

#-- encoding: UTF-8



module Bim::Bcf::API::V2_1
  class ProjectExtensions::Representer < BaseRepresenter
    property :topic_type,
             getter: ->(decorator:, **) {
               decorator.with_check do
                 assignable_types.pluck(:name)
               end
             }

    # TODO: Labels do not yet exist
    property :topic_label,
             getter: ->(*) {
               []
             }

    # TODO: Snippet types do not exist
    property :snippet_type,
             getter: ->(*) {
               []
             }

    property :priority,
             getter: ->(decorator:, **) {
               decorator.with_check do
                 assignable_priorities.pluck(:name)
               end
             }

    property :user_id_type,
             getter: ->(decorator:, **) {
               decorator.with_check(%i[manage_bcf view_members]) do
                 assignable_assignees.pluck(:mail)
               end
             }

    # TODO: Stage do not yet exist
    property :stage,
             getter: ->(*) {
               []
             }

    property :project_actions,
             getter: ->(decorator:, **) {
               [].tap do |actions|
                 actions << 'update' if decorator.allowed?(:edit_project)

                 if decorator.allowed?(:manage_bcf)
                   actions << 'viewTopic' << 'createTopic'
                 elsif decorator.allowed?(:view_linked_issues)
                   actions << 'viewTopic'
                 end
               end
             }

    property :comment_actions,
             getter: ->(*) {
               []
             }

    def to_hash(*)
      topic_authorization = ::Bim::Bcf::API::V2_1::Topics::AuthorizationRepresenter
                            .new(represented)

      super.merge(topic_authorization.to_hash)
    end

    def with_check(permissions = :manage_bcf)
      if Array(permissions).all? { |permission| allowed?(permission) }
        yield
      else
        []
      end
    end

    def allowed?(permission)
      represented.user.allowed_to?(permission, represented.model.project)
    end
  end
end

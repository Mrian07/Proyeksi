

module Bim::Bcf::API::V2_1
  class Comments::SingleRepresenter < BaseRepresenter
    include API::Decorators::DateProperty

    property :uuid,
             as: :guid

    property :date,
             getter: ->(represented:, decorator:, **) {
               decorator.datetime_formatter.format_datetime(represented.journal.created_at, allow_nil: true)
             }

    property :author,
             getter: ->(represented:, **) {
               represented.journal.user.mail
             }

    property :comment,
             getter: ->(represented:, **) {
               represented.journal.notes
             }

    property :topic_guid,
             getter: ->(represented:, **) {
               represented.issue.uuid
             }

    # not required properties
    property :viewpoint_guid,
             getter: ->(represented:, **) {
               represented.viewpoint&.uuid
             }

    property :reply_to_comment_guid,
             getter: ->(represented:, **) {
               represented.reply_to&.uuid
             }

    property :modified_date,
             getter: ->(represented:, decorator:, **) {
               decorator.datetime_formatter.format_datetime(represented.journal.updated_at, allow_nil: true)
             }

    # we do not store the author when editing a journal, hence the "modified author" is the same as the creator
    property :modified_author,
             getter: ->(represented:, **) {
               represented.journal.user.mail
             }

    property :authorization,
             getter: ->(represented:, **) {
               contract = WorkPackages::UpdateContract.new(represented.issue.work_package, User.current)
               Comments::AuthorizationRepresenter.new(contract)
             }
  end
end

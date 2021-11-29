#-- encoding: UTF-8



module API
  module V3
    module Capabilities
      class CapabilitySqlRepresenter
        include API::Decorators::Sql::Hal

        property :_type,
                 representation: ->(*) { "'Capability'" }

        property :id,
                 representation: ->(*) {
                   <<~SQL
                     CASE
                     WHEN context_id IS NULL THEN action || '/g-' || principal_id
                     ELSE action || '/p' || context_id || '-' || principal_id
                     END
                   SQL
                 }

        link :self,
             path: { api: :capability, params: %w(action) },
             column: -> {
               <<~SQL
                 CASE
                 WHEN context_id IS NULL THEN action || '/g-' || principal_id
                 ELSE action || '/p' || context_id || '-' || principal_id
                 END
               SQL
             },
             title: -> { nil }

        link :action,
             path: { api: :action, params: %w(action) },
             title: -> { nil }

        link :context,
             href: ->(*) {
               <<~SQL
                 CASE
                 WHEN context_id IS NULL THEN '#{api_v3_paths.capabilities_contexts_global}'
                 ELSE format('#{api_v3_paths.project('%s')}', context_id)
                 END
               SQL
             },
             title: ->(*) {
               <<~SQL
                 CASE
                 WHEN context_id IS NULL THEN '#{I18n.t('activerecord.errors.models.capability.context.global')}'
                 ELSE context_name
                 END
               SQL
             },
             join: { table: :projects,
                     condition: "contexts.id = capabilities.context_id",
                     select: ['contexts.name context_name'] }

        link :principal,
             href: ->(*) {
               <<~SQL
                 CASE principal_type
                 WHEN 'Group' THEN format('#{api_v3_paths.group('%s')}', principal_id)
                 WHEN 'PlaceholderUser' THEN format('#{api_v3_paths.placeholder_user('%s')}', principal_id)
                 ELSE format('#{api_v3_paths.user('%s')}', principal_id)
                 END
               SQL
             },
             title: -> {
               join_string = if Setting.user_format == :lastname_coma_firstname
                               " || ', ' || "
                             else
                               " || ' ' || "
                             end

               <<~SQL
                 CASE principal_type
                 WHEN 'Group' THEN lastname
                 WHEN 'PlaceholderUser' THEN lastname
                 ELSE #{User::USER_FORMATS_STRUCTURE[Setting.user_format].map { |p| p }.join(join_string)}
                 END
               SQL
             },
             join: { table: :users,
                     condition: "principals.id = capabilities.principal_id",
                     select: ['principals.firstname',
                              'principals.lastname',
                              'principals.login',
                              'principals.mail',
                              'principals.type principal_type'] }
      end
    end
  end
end

#-- encoding: UTF-8



require 'api/decorators/single'

module API
  module V3
    class RootRepresenter < ::API::Decorators::Single
      link :self do
        {
          href: api_v3_paths.root
        }
      end

      link :configuration do
        {
          href: api_v3_paths.configuration
        }
      end

      link :memberships do
        next unless current_user.allowed_to?(:view_members, nil, global: true) ||
                    current_user.allowed_to?(:manage_members, nil, global: true)

        {
          href: api_v3_paths.memberships
        }
      end

      link :priorities do
        {
          href: api_v3_paths.priorities
        }
      end

      link :relations do
        {
          href: api_v3_paths.relations
        }
      end

      link :statuses do
        {
          href: api_v3_paths.statuses
        }
      end

      link :time_entries do
        {
          href: api_v3_paths.time_entries
        }
      end

      link :types do
        {
          href: api_v3_paths.types
        }
      end

      link :user do
        next unless current_user.logged?

        {
          href: api_v3_paths.user(current_user.id),
          title: current_user.name
        }
      end

      link :userPreferences do
        {
          href: api_v3_paths.user_preferences(current_user.id)
        }
      end

      link :workPackages do
        {
          href: api_v3_paths.work_packages
        }
      end

      property :instance_name,
               getter: ->(*) { Setting.app_title }

      property :core_version,
               exec_context: :decorator,
               getter: ->(*) { ProyeksiApp::VERSION.to_semver },
               if: ->(*) { current_user.admin? }

      def _type
        'Root'
      end
    end
  end
end

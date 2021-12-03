#-- encoding: UTF-8



module ProyeksiApp
  module Ui
    class ExtensibleTabs
      class << self
        def tabs
          @tabs ||= {
            user: core_user_tabs,
            placeholder_user: core_placeholder_user_tabs
          }
        end

        ##
        # Get all enabled tabs for the given key
        def enabled_tabs(key, context = {})
          tabs[key].select { |entry| entry[:only_if].nil? || entry[:only_if].call(context) }
        end

        # Add a new tab for the given key
        def add(key, **entry)
          tabs[key] = [] if tabs[key].nil?

          raise ArgumentError.new "Invalid entry for tab #{key}" unless entry[:name] && entry[:partial]

          tabs[key] << entry
        end

        private

        def core_user_tabs
          [
            {
              name: 'general',
              partial: 'users/general',
              path: ->(params) { edit_user_path(params[:user], tab: :general) },
              label: :label_general
            },
            {
              name: 'memberships',
              partial: 'individual_principals/memberships',
              path: ->(params) { edit_user_path(params[:user], tab: :memberships) },
              label: :label_project_plural
            },
            {
              name: 'groups',
              partial: 'users/groups',
              path: ->(params) { edit_user_path(params[:user], tab: :groups) },
              label: :label_group_plural,
              only_if: ->(*) { User.current.admin? && Group.any? }
            },
            {
              name: 'global_roles',
              partial: 'users/global_roles',
              path: ->(params) { edit_user_path(params[:user], tab: :global_roles) },
              label: :label_global_roles,
              only_if: ->(*) { User.current.admin? }
            },
            {
              name: 'notifications',
              partial: 'users/notifications',
              path: ->(params) { edit_user_path(params[:user], tab: :notifications) },
              label: :'notifications.settings.title'
            },
            {
              name: 'reminders',
              partial: 'users/reminders',
              path: ->(params) { edit_user_path(params[:user], tab: :reminders) },
              label: :'reminders.settings.title'
            }
          ]
        end

        def core_placeholder_user_tabs
          [
            {
              name: 'general',
              partial: 'placeholder_users/general',
              path: ->(params) { edit_placeholder_user_path(params[:placeholder_user], tab: :general) },
              label: :label_general
            },
            {
              name: 'memberships',
              partial: 'individual_principals/memberships',
              path: ->(params) { edit_placeholder_user_path(params[:placeholder_user], tab: :memberships) },
              label: :label_project_plural
            }
          ]
        end
      end
    end
  end
end

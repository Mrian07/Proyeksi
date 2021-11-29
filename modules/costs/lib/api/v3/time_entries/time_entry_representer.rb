#-- encoding: UTF-8



module API
  module V3
    module TimeEntries
      class TimeEntryRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::FormattableProperty
        include API::Decorators::DateProperty
        extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass

        self_link title_getter: ->(*) { nil }

        defaults render_nil: true

        link :updateImmediately do
          next unless update_allowed?

          {
            href: api_v3_paths.time_entry(represented.id),
            method: :patch
          }
        end

        link :update do
          next unless update_allowed?

          {
            href: api_v3_paths.time_entry_form(represented.id),
            method: :post
          }
        end

        link :delete do
          next unless update_allowed?

          {
            href: api_v3_paths.time_entry(represented.id),
            method: :delete
          }
        end

        link :schema do
          {
            href: api_v3_paths.time_entry_schema
          }
        end

        property :id

        formattable_property :comments,
                             as: :comment,
                             plain: true

        date_property :spent_on

        property :hours,
                 exec_context: :decorator,
                 getter: ->(*) do
                   datetime_formatter.format_duration_from_hours(represented.hours) if represented.hours
                 end

        date_time_property :created_at
        date_time_property :updated_at

        associated_resource :project

        associated_resource :work_package,
                            link_title_attribute: :subject

        associated_resource :user

        associated_resource :activity,
                            representer: TimeEntriesActivityRepresenter,
                            v3_path: :time_entries_activity,
                            setter: ->(fragment:, **) {
                              ::API::Decorators::LinkObject
                                .new(represented,
                                     path: :time_entries_activity,
                                     property_name: :time_entries_activity,
                                     namespace: 'time_entries/activities',
                                     getter: :activity_id,
                                     setter: :"activity_id=")
                                .from_hash(fragment)
                            }

        def _type
          'TimeEntry'
        end

        def update_allowed?
          current_user_allowed_to(:edit_time_entries, context: represented.project) ||
            represented.user_id == current_user.id &&
              current_user_allowed_to(:edit_own_time_entries, context: represented.project)
        end

        def current_user_allowed_to(permission, context:)
          current_user.allowed_to?(permission, context)
        end

        def hours=(value)
          represented.hours = datetime_formatter.parse_duration_to_hours(value,
                                                                         'hours',
                                                                         allow_nil: true)
        end
      end
    end
  end
end

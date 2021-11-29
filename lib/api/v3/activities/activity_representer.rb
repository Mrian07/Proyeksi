#-- encoding: UTF-8



API::V3::Utilities::DateTimeFormatter

module API
  module V3
    module Activities
      class ActivityRepresenter < ::API::Decorators::Single
        include API::V3::Utilities
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include ActivityPropertyFormatters

        self_link path: :activity,
                  title_getter: ->(*) { nil }

        link :workPackage do
          {
            href: api_v3_paths.work_package(represented.journable.id),
            title: represented.journable.subject.to_s
          }
        end

        link :user do
          {
            href: api_v3_paths.user(represented.user_id)
          }
        end

        link :update do
          next unless current_user_allowed_to_edit?

          {
            href: api_v3_paths.activity(represented.id),
            method: :patch
          }
        end

        property :id,
                 render_nil: true

        formattable_property :notes,
                             as: :comment,
                             getter: ->(*) { formatted_notes(represented) }

        property :details,
                 exec_context: :decorator,
                 getter: ->(*) { formatted_details(represented) },
                 render_nil: true

        property :version, render_nil: true

        date_time_property :created_at

        def _type
          if represented.noop? || represented.notes.present?
            'Activity::Comment'
          else
            'Activity'
          end
        end

        private

        def current_user_allowed_to_edit?
          represented.editable_by?(current_user)
        end

        def render_details(journal, no_html: false)
          journal.details.map { |d| journal.render_detail(d, no_html: no_html) }
        end
      end
    end
  end
end

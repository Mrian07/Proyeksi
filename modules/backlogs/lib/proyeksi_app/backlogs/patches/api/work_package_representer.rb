

module ProyeksiApp::Backlogs
  module Patches
    module API
      module WorkPackageRepresenter
        module_function

        # rubocop:disable Metrics/AbcSize
        def extension
          ->(*) do
            property :position,
                     render_nil: true,
                     skip_render: ->(*) { !(backlogs_enabled? && type && type.passes_attribute_constraint?(:position)) }

            property :story_points,
                     render_nil: true,
                     skip_render: ->(*) { !(backlogs_enabled? && type && type.passes_attribute_constraint?(:story_points)) }

            property :remaining_time,
                     exec_context: :decorator,
                     render_nil: true,
                     skip_render: ->(represented:, **) { !represented.backlogs_enabled? }

            # cannot use def here as it wouldn't define the method on the representer
            define_method :remaining_time do
              datetime_formatter.format_duration_from_hours(represented.remaining_hours,
                                                            allow_nil: true)
            end

            define_method :remaining_time= do |value|
              remaining = datetime_formatter.parse_duration_to_hours(value,
                                                                     'remainingTime',
                                                                     allow_nil: true)
              represented.remaining_hours = remaining
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end

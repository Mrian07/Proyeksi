

module OpenProject::Backlogs
  module Patches
    module API
      module WorkPackageSchemaRepresenter
        module_function

        # rubocop:disable Metrics/AbcSize
        def extension
          ->(*) do
            schema :position,
                   type: 'Integer',
                   required: false,
                   writable: false,
                   show_if: ->(*) {
                     backlogs_constraint_passed?(:position)
                   }

            schema :story_points,
                   type: 'Integer',
                   required: false,
                   show_if: ->(*) {
                     backlogs_constraint_passed?(:story_points)
                   }

            schema :remaining_time,
                   type: 'Duration',
                   name_source: :remaining_hours,
                   required: false,
                   show_if: ->(*) { represented.project && represented.project.backlogs_enabled? }

            define_method :backlogs_constraint_passed? do |attribute|
              represented.project&.backlogs_enabled? &&
                (!represented.type || represented.type.passes_attribute_constraint?(attribute))
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end

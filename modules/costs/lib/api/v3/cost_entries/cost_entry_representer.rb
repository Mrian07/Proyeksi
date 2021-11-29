

module API
  module V3
    module CostEntries
      class CostEntryRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::DateProperty

        self_link title_getter: ->(*) { nil }
        associated_resource :project
        associated_resource :user
        associated_resource :cost_type

        # for now not embedded, because work packages are quite large
        associated_resource :work_package,
                            getter: ->(*) {},
                            link_title_attribute: :subject

        property :id, render_nil: true
        property :units, as: :spentUnits

        date_property :spent_on

        date_time_property :created_at
        date_time_property :updated_at

        def _type
          'CostEntry'
        end
      end
    end
  end
end

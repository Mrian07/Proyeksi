

module API
  module V3
    module CostEntries
      # N.B. This class is currently quite specifically crafted for the aggregation of cost entries
      # of a single work package by their type. This might be improved in the future™
      class AggregatedCostEntryRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource

        def initialize(cost_type, units)
          @cost_type = cost_type
          @spent_units = units

          super(nil, current_user: nil)
        end

        resource :costType,
                 link: ->(*) {
                   {
                     href: api_v3_paths.cost_type(@cost_type.id),
                     title: @cost_type.name
                   }
                 },
                 getter: ->(*) {
                   ::API::V3::CostTypes::CostTypeRepresenter.new(@cost_type, current_user: current_user)
                 },
                 setter: ->(*) {}

        property :budget_id,
                 exec_context: :decorator,
                 getter: ->(*) {
                   @cost_type.id
                 }

        property :spent_units,
                 exec_context: :decorator,
                 getter: ->(*) { @spent_units }

        link :staticPath do
          {
            href: budget_path(@cost_type.id)
          }
        end

        def _type
          'AggregatedCostEntry'
        end

        def model_required?
          false
        end
      end
    end
  end
end

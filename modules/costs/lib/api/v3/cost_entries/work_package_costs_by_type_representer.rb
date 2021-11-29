#-- encoding: UTF-8



module API
  module V3
    module CostEntries
      # Ripped from ::API::Decorators::Collection, which does not support injecting
      # decorators directly
      # This class should use the Collection class directly (or inherit from it) in the future
      class WorkPackageCostsByTypeRepresenter < ::API::Decorators::Single
        link :self do
          { href: api_v3_paths.summarized_work_package_costs_by_type(represented.id) }
        end

        property :total,
                 exec_context: :decorator,
                 getter: ->(*) { cost_helper.summarized_cost_entries.size }
        property :count,
                 exec_context: :decorator,
                 getter: ->(*) { cost_helper.summarized_cost_entries.size }

        collection :elements,
                   getter: ->(*) {
                     cost_helper.summarized_cost_entries.map do |kvp|
                       type = kvp[0]
                       units = kvp[1]
                       ::API::V3::CostEntries::AggregatedCostEntryRepresenter.new(type, units)
                     end
                   },
                   exec_context: :decorator,
                   embedded: true

        def cost_helper
          @cost_helper ||= ::Costs::AttributesHelper.new(represented, current_user)
        end

        def _type
          'Collection'
        end
      end
    end
  end
end

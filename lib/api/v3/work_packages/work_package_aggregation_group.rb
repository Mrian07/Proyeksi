#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      class WorkPackageAggregationGroup < ::API::Decorators::AggregationGroup
        def initialize(group_key, count, query:, current_user:, sums: nil)
          @sums = sums

          super(group_key, count, query: query, current_user: current_user)
        end

        property :sums,
                 exec_context: :decorator,
                 getter: ->(*) {
                   ::API::V3::WorkPackages::WorkPackageSumsRepresenter.create(sums, current_user) if sums
                 },
                 render_nil: false

        link :groupBy do
          converted_name = convert_attribute(query.group_by_column.name)

          {
            href: api_v3_paths.query_group_by(converted_name),
            title: query.group_by_column.caption
          }
        end

        def has_sums?
          sums.present?
        end

        attr_reader :sums

        def value
          if query.group_by_column.name == :done_ratio
            "#{represented}%"
          else
            super
          end
        end
      end
    end
  end
end

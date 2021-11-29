#-- encoding: UTF-8



module API
  module V3
    module Activities
      class ActivityEagerLoadingWrapper < API::V3::Utilities::EagerLoading::EagerLoadingWrapper
        class << self
          def wrap(journals)
            if journals.any?
              set_journable(journals)
              set_predecessor(journals)
              set_data(journals)
            end

            super
          end

          private

          def set_journable(journals)
            journables = journable_by_type_and_id(journals)

            journals.each do |journal|
              journal.journable = journables[journal.journable_type][journal.journable_id]
            end
          end

          def set_predecessor(journals)
            predecessors = predecessors_by_type_and_id(journals)

            journals.each do |journal|
              next unless predecessors[journal.journable_type]

              predecessor = predecessors[journal.journable_type][journal.journable_id]&.find { |j| j.version < journal.version }

              journal.instance_variable_set(:@predecessor, predecessor)
            end
          end

          def set_data(journals)
            data = data_by_type_and_id(journals)

            journals.each do |journal|
              journal.data = data[journal.data_type][journal.data_id]
              journal.previous.data = data[journal.data_type][journal.previous.data_id] if journal.previous.present?
            end
          end

          def journable_by_type_and_id(journals)
            journals.map(&:journable_type).uniq.each_with_object(Hash.new([])) do |class_name, hash|
              hash[class_name] = class_name
                                   .constantize
                                   .where(id: journals.map(&:journable_id))
                                   .includes(:project)
                                   .group_by(&:id)
                                   .transform_values(&:first)
            end
          end

          def data_by_type_and_id(journals)
            # Assuming that
            # * the journable has already been loaded by #set_journable
            # * previous has already been loaded by #set_predecessor
            journals
              .group_by(&:data_type)
              .each_with_object(Hash.new({})) do |(class_name, class_journals), hash|
              hash[class_name] = class_name
                                   .constantize
                                   .find(data_ids(class_journals))
                                   .group_by(&:id)
                                   .transform_values(&:first)
            end
          end

          def predecessors_by_type_and_id(journals)
            predecessor_journals(journals)
              .group_by(&:journable_type)
              .transform_values do |v|
              v
                .group_by(&:journable_id)
                .transform_values { |j| j.sort_by(&:version).reverse }
            end
          end

          def data_ids(journals)
            journals.map { |j| [j.data_id, j.previous&.data_id] }.flatten.compact
          end

          def predecessor_journals(journals)
            current = journals.map { |j| [j.journable_type, j.journable_id, j.version] }

            Journal
              .from(
                <<~SQL.squish
                  (SELECT DISTINCT ON (predecessors.journable_type, predecessors.journable_id, current.version)
                  predecessors.*
                  FROM
                  #{Journal.arel_table.grouping(Arel::Nodes::ValuesList.new(current)).as('current(journable_type, journable_id, version)').to_sql}
                  JOIN journals predecessors
                  ON
                  current.journable_type = predecessors.journable_type
                  AND current.journable_id = predecessors.journable_id
                  AND current.version > predecessors.version
                  ORDER BY predecessors.journable_type, predecessors.journable_id, current.version, predecessors.version DESC
                  ) AS journals
                SQL
              )
              .includes(:attachable_journals, :customizable_journals)
          end
        end
      end
    end
  end
end

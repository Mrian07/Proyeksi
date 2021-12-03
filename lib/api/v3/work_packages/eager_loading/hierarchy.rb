#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      module EagerLoading
        class Hierarchy < Base
          def apply(work_package)
            work_package.association(:children).loaded!
            work_package.association(:children).target = children(work_package.id)
          end

          private

          def children(id)
            @children ||= WorkPackage
                            .joins(:parent_relation)
                            .where(relations: { from_id: work_packages.map(&:id) })
                            .select(:id, :subject, :project_id, :from_id)
                            .group_by(&:from_id).to_h

            @children[id] || []
          end
        end
      end
    end
  end
end

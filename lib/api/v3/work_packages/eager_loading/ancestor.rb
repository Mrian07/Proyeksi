#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module EagerLoading
        class Ancestor < Base
          def apply(work_package)
            work_package.work_package_ancestors = ancestors[work_package.id] || []
          end

          private

          def ancestors
            @ancestors ||= WorkPackage.aggregate_ancestors(work_packages.map(&:id), User.current)
          end
        end
      end
    end
  end
end

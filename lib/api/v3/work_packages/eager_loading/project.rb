#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module EagerLoading
        class Project < Base
          def apply(work_package)
            work_package.project = project_for(work_package.project_id)
            work_package.parent.project = project_for(work_package.parent.project_id) if work_package.parent

            work_package.children.each do |child|
              child.project = project_for(child.project_id)
            end
          end

          private

          def project_for(project_id)
            projects_by_id[project_id]
          end

          def projects_by_id
            @projects_by_id ||= begin
              ::Project
                .includes(:enabled_modules)
                .where(id: project_ids)
                .to_a
                .map { |p| [p.id, p] }
                .to_h
            end
          end

          def project_ids
            work_packages.map do |work_package|
              [work_package.project_id, work_package.parent && work_package.parent.project_id] +
                work_package.children.map(&:project_id)
            end.flatten.uniq.compact
          end
        end
      end
    end
  end
end

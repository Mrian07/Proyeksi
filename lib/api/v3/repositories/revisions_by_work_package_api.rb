require 'api/v3/repositories/revision_collection_representer'

module API
  module V3
    module Repositories
      class RevisionsByWorkPackageAPI < ::API::ProyeksiAppAPI
        resources :revisions do
          after_validation do
            authorize(:view_work_packages, context: work_package.project)
          end

          get do
            self_path = api_v3_paths.work_package_revisions(work_package.id)

            revisions = work_package.changesets.visible
            RevisionCollectionRepresenter.new(revisions, self_link: self_path, current_user: current_user)
          end
        end
      end
    end
  end
end

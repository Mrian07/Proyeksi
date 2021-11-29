
module API
  module V3
    module Repositories
      class RevisionsAPI < ::API::OpenProjectAPI
        resources :revisions do
          route_param :id, type: Integer, desc: 'Revision ID' do
            helpers do
              attr_reader :revision

              def revision_representer
                RevisionRepresenter.new(revision, current_user: current_user)
              end
            end

            after_validation do
              @revision = Changeset.find(params[:id])

              authorize(:view_changesets, context: revision.project) do
                raise API::Errors::NotFound.new
              end
            end

            get do
              revision_representer
            end
          end
        end
      end
    end
  end
end

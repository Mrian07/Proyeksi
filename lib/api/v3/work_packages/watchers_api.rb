

require 'hashie'

module API
  module V3
    module WorkPackages
      class WatchersAPI < ::API::ProyeksiAppAPI
        helpers ::API::Utilities::PageSizeHelper

        get '/available_watchers' do
          authorize(:add_work_package_watchers, context: @work_package.project)

          service = ParamsToQueryService.new(User, current_user)
          query = service.call(params)

          if query.valid?
            users = query.results.merge(@work_package.addable_watcher_users).includes(:preference)
            ::API::V3::Users::PaginatedUserCollectionRepresenter.new(
              users,
              self_link: api_v3_paths.users,
              page: to_i_or_nil(params[:offset]),
              per_page: resolve_page_size(params[:pageSize]),
              current_user: current_user
            )
          else
            raise ::API::Errors::InvalidQuery.new(query.errors.full_messages)
          end
        end

        resources :watchers do
          helpers do
            def watchers_collection
              watchers = @work_package.watcher_users.merge(Principal.not_locked)
              self_link = api_v3_paths.work_package_watchers(@work_package.id)
              Users::UserCollectionRepresenter.new(watchers,
                                                   self_link: self_link,
                                                   current_user: current_user)
            end
          end

          get do
            authorize(:view_work_package_watchers, context: @work_package.project)

            watchers_collection
          end

          post do
            unless request_body
              fail ::API::Errors::InvalidRequestBody.new(I18n.t('api_v3.errors.missing_request_body'))
            end

            representer = ::API::V3::Watchers::WatcherRepresenter.new(::Hashie::Mash.new)
            representer.from_hash(request_body)
            user_id = representer.represented.user_id.to_i

            if current_user.id == user_id
              authorize(:view_work_packages, context: @work_package.project)
            else
              authorize(:add_work_package_watchers, context: @work_package.project)
            end

            user = User.find user_id

            Services::CreateWatcher.new(@work_package, user).run(
              success: ->(result) { status(200) unless result[:created] },
              failure: ->(watcher) {
                raise ::API::Errors::ErrorBase.create_and_merge_errors(watcher.errors)
              }
            )

            ::API::V3::Users::UserRepresenter.new(user, current_user: current_user)
          end

          namespace ':user_id' do
            params do
              requires :user_id, desc: 'The watcher\'s user id', type: Integer
            end

            delete do
              if current_user.id == params[:user_id]
                authorize(:view_work_packages, context: @work_package.project)
              else
                authorize(:delete_work_package_watchers, context: @work_package.project)
              end

              user = User.find_by(id: params[:user_id])

              raise ::API::Errors::NotFound unless user

              Services::RemoveWatcher.new(@work_package, user).run

              status 204
            end
          end
        end
      end
    end
  end
end

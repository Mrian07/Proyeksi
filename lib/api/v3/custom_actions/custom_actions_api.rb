module API
  module V3
    module CustomActions
      class CustomActionsAPI < ::API::ProyeksiAppAPI
        resources :custom_actions do
          route_param :id, type: Integer, desc: 'Custom action ID' do
            helpers do
              def custom_action
                @custom_action ||= CustomAction.find(params[:id])
              end
            end

            helpers ::API::V3::WorkPackages::WorkPackagesSharedHelpers

            after_validation do
              authorize(:edit_work_packages, global: true)
            end

            get do
              ::API::V3::CustomActions::CustomActionRepresenter.new(custom_action,
                                                                    current_user: current_user)
            end

            namespace 'execute' do
              helpers do
                def parsed_params
                  @parsed_params ||= begin
                                       struct = OpenStruct.new

                                       representer = ::API::V3::CustomActions::CustomActionExecuteRepresenter.new(struct,
                                                                                                                  current_user: current_user)
                                       representer.from_hash(Hash(request_body))
                                     end
                end
              end

              after_validation do
                contract = ::CustomActions::ExecuteContract.new(parsed_params, current_user)

                unless contract.valid?
                  fail ::API::Errors::ErrorBase.create_and_merge_errors(contract.errors)
                end
              end

              post do
                work_package = WorkPackage.visible.find_by(id: parsed_params.work_package_id)
                work_package.lock_version = parsed_params.lock_version

                ::CustomActions::UpdateWorkPackageService
                  .new(user: current_user,
                       action: custom_action)
                  .call(work_package: work_package) do |call|
                  call.on_success do
                    work_package.reload

                    status 200
                    body(::API::V3::WorkPackages::WorkPackageRepresenter.create(
                      work_package,
                      current_user: current_user,
                      embed_links: true
                    ))
                  end

                  call.on_failure do
                    fail ::API::Errors::ErrorBase.create_and_merge_errors(call.errors)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

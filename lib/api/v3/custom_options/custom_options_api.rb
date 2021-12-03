#-- encoding: UTF-8

module API
  module V3
    module CustomOptions
      class CustomOptionsAPI < ::API::ProyeksiAppAPI
        resources :custom_options do
          namespace ':id' do
            params do
              requires :id, type: Integer
            end

            helpers do
              def authorize_view_in_activated_project(custom_option)
                allowed = Project
                            .allowed_to(current_user, :view_work_packages)
                            .joins(:work_package_custom_fields)
                            .where(custom_fields: { id: custom_option.custom_field_id })
                            .exists?

                unless allowed
                  raise API::Errors::NotFound
                end
              end
            end

            get do
              co = CustomOption.find(params[:id])

              authorize_view_in_activated_project(co)

              CustomOptionRepresenter.new(co, current_user: current_user)
            end
          end
        end
      end
    end
  end
end

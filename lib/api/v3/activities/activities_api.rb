

module API
  module V3
    module Activities
      class ActivitiesAPI < ::API::OpenProjectAPI
        resources :activities do
          route_param :id, type: Integer, desc: 'Activity ID' do
            after_validation do
              @activity = Journal.find(declared_params[:id])

              authorize_by_with_raise @activity.journable.visible?(current_user) do
                raise API::Errors::NotFound
              end
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: ::Journal,
                                                           api_name: 'Activity',
                                                           instance_generator: ->(*) { @activity })
                                                      .mount

            params do
              requires :comment, type: String
            end

            patch &::API::V3::Utilities::Endpoints::Update.new(model: ::Journal,
                                                               api_name: 'Activity',
                                                               instance_generator: ->(*) { @activity },
                                                               params_modifier: ->(*) {
                                                                 { notes: declared_params[:comment] }
                                                               })
                                                          .mount
          end
        end
      end
    end
  end
end

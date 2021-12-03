

module API
  module V3
    module Grids
      class UpdateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          post &::API::V3::Utilities::Endpoints::UpdateForm.new(model: ::Grids::Grid,
                                                                params_modifier: ->(params) {
                                                                  if params[:scope]
                                                                    params[:type] = ::Grids::Configuration
                                                                                    .class_from_scope(params.delete(:scope))
                                                                                    .to_s
                                                                  end

                                                                  params
                                                                })
                                                           .mount
        end
      end
    end
  end
end

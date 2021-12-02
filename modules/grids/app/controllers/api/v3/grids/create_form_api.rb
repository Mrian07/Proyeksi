

module API
  module V3
    module Grids
      class CreateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          post &::API::V3::Utilities::Endpoints::CreateForm.new(model: ::Grids::Grid,
                                                                instance_generator: ->(params) {
                                                                  ::Grids::Factory.build(params.delete(:scope), current_user)
                                                                })
                                                           .mount
        end
      end
    end
  end
end



module API
  module V3
    module Memberships
      class UpdateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          after_validation do
            authorize :manage_members, global: true
          end

          post &::API::V3::Utilities::Endpoints::UpdateForm
                  .new(model: Member,
                       api_name: 'Membership',
                       params_modifier: ->(params) do
                         params.except(:meta)
                       end,
                       process_state: ->(params:, **) do
                         params[:meta].deep_dup
                       end)
                  .mount
        end
      end
    end
  end
end

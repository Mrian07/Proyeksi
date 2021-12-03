module API
  module V3
    module Memberships
      class CreateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          after_validation do
            authorize :manage_members, global: true
          end

          post &::API::V3::Utilities::Endpoints::CreateForm
                  .new(model: Member,
                       instance_generator: ->(params) {
                         # This here is a hack to circumvent the strange
                         # way roles are assigned to a member within 3 models.
                         # As this is never saved, we do not have to care for
                         # that elaborate process.
                         # Doing this leads to the roles being displayed
                         # in the payload.
                         roles = if params[:role_ids]
                                   Array(Role.find_by(id: params.delete(:role_ids)))
                                 end || []

                         Member.new(roles: roles)
                       },
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

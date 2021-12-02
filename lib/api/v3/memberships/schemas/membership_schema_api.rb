

module API
  module V3
    module Memberships
      module Schemas
        class MembershipSchemaAPI < ::API::ProyeksiAppAPI
          resources :schema do
            after_validation do
              authorize_any %i[manage_members view_members],
                            global: true
            end

            get &::API::V3::Utilities::Endpoints::Schema.new(model: Member,
                                                             contract: Members::CreateContract,
                                                             api_name: 'Membership')
                                                        .mount
          end
        end
      end
    end
  end
end

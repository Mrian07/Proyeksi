

module API
  module V3
    module Memberships
      class MembershipsAPI < ::API::OpenProjectAPI
        helpers ::API::Utilities::PageSizeHelper

        resources :memberships do
          get &::API::V3::Utilities::Endpoints::Index
                 .new(model: Member,
                      scope: -> { Member.includes(MembershipRepresenter.to_eager_load) },
                      api_name: 'Membership')
                 .mount

          post &::API::V3::Utilities::Endpoints::Create
                  .new(model: Member,
                       api_name: 'Membership',
                       params_modifier: ->(params) {
                         params.except(:meta).merge(params.fetch(:meta, {}).to_h)
                       })
                  .mount

          mount ::API::V3::Memberships::AvailableProjectsAPI
          mount ::API::V3::Memberships::Schemas::MembershipSchemaAPI
          mount ::API::V3::Memberships::CreateFormAPI

          route_param :id, type: Integer, desc: 'Member ID' do
            after_validation do
              @member = ::Queries::Members::MemberQuery
                        .new(user: current_user)
                        .results
                        .find(params['id'])
            end

            get &::API::V3::Utilities::Endpoints::Show
                   .new(model: Member,
                        api_name: 'Membership')
                   .mount

            patch &::API::V3::Utilities::Endpoints::Update
                     .new(model: Member,
                          api_name: 'Membership',
                          params_modifier: ->(params) {
                            params.except(:meta).merge(params.fetch(:meta, {}).to_h)
                          })
                     .mount

            delete &::API::V3::Utilities::Endpoints::Delete
                      .new(model: Member)
                      .mount

            mount ::API::V3::Memberships::UpdateFormAPI
          end
        end
      end
    end
  end
end

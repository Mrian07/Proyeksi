

require 'spec_helper'
require 'work_package'

describe Users::MembershipsController, type: :controller do
  shared_let(:admin) { FactoryBot.create :admin }

  let(:user) { FactoryBot.create(:user) }
  let(:anonymous) { FactoryBot.create(:anonymous) }

  describe 'update memberships' do
    let(:project) { FactoryBot.create(:project) }
    let(:role) { FactoryBot.create(:role) }

    it 'works' do
      # i.e. it should successfully add a user to a project's members
      as_logged_in_user admin do
        post :create,
             params: {
               user_id: user.id,
               membership: {
                 project_id: project.id,
                 role_ids: [role.id]
               }
             }
      end

      expect(response).to redirect_to(controller: '/users', action: 'edit', id: user.id, tab: 'memberships')

      is_member = user.reload.memberships.any? do |m|
        m.project_id == project.id && m.role_ids.include?(role.id)
      end
      expect(is_member).to eql(true)
    end
  end
end

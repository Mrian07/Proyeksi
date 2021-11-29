

require 'spec_helper'

describe Queries::Principals::PrincipalQuery, 'integration', type: :model do
  let(:current_user) { FactoryBot.create(:user) }
  let(:instance) { described_class.new }

  before do
    login_as(current_user)
  end

  context 'with a member filter' do
    let(:project) { FactoryBot.create(:project) }
    let(:role) { FactoryBot.create(:role) }
    let(:project_user) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_through_role: role) do |u|
        # Granting another membership in order to better test the "not" filter
        FactoryBot.create(:member,
                          principal: u,
                          project: other_project,
                          roles: [role])
      end
    end
    let(:other_project) { FactoryBot.create(:project) }
    let(:other_project_user) do
      FactoryBot.create(:user,
                        member_in_project: other_project,
                        member_through_role: role)
    end

    let(:users) { [current_user, project_user, other_project_user] }

    before do
      users
    end

    context 'with the = operator' do
      before do
        instance.where('member', '=', [project.id.to_s])
      end

      it 'returns all principals being member' do
        expect(instance.results)
          .to match_array [project_user]
      end
    end

    context 'with the ! operator' do
      before do
        instance.where('member', '!', [project.id.to_s])
      end

      it 'returns all principals not being member' do
        expect(instance.results)
          .to match_array [current_user, other_project_user]
      end
    end
  end
end

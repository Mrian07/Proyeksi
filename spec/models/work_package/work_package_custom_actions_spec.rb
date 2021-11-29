#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackage, 'custom_actions', type: :model do
  let(:work_package) do
    FactoryBot.build_stubbed(:stubbed_work_package,
                             project: project)
  end
  let(:project) { FactoryBot.create(:project) }
  let(:status) { FactoryBot.create(:status) }
  let(:other_status) { FactoryBot.create(:status) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: work_package.project,
                      member_through_role: role)
  end
  let(:role) do
    FactoryBot.create(:role)
  end
  let(:conditions) do
    [CustomActions::Conditions::Status.new([status.id])]
  end

  let!(:custom_action) do
    action = FactoryBot.build(:custom_action)
    action.conditions = conditions

    action.save!
    action
  end

  describe '#custom_actions' do
    context 'with the custom action having no restriction' do
      let(:conditions) do
        []
      end

      before do
        work_package.status_id = status.id
      end

      it 'returns the action' do
        expect(work_package.custom_actions(user))
          .to match_array [custom_action]
      end
    end

    context 'with a status restriction' do
      context 'with the work package having the same status' do
        before do
          work_package.status_id = status.id
        end

        it 'returns the action' do
          expect(work_package.custom_actions(user))
            .to match_array [custom_action]
        end
      end

      context 'with the work package having a different status' do
        before do
          work_package.status_id = other_status.id
        end

        it 'does not return the action' do
          expect(work_package.custom_actions(user))
            .to be_empty
        end
      end
    end

    context 'with a role restriction' do
      let(:conditions) do
        [CustomActions::Conditions::Role.new(role.id)]
      end

      context 'with the user having the same role' do
        it 'returns the action' do
          expect(work_package.custom_actions(user))
            .to match_array [custom_action]
        end
      end

      context 'with the condition requiring a different role' do
        let(:other_role) { FactoryBot.create(:role) }

        let(:conditions) do
          [CustomActions::Conditions::Role.new(other_role.id)]
        end

        it 'does not return the action' do
          expect(work_package.custom_actions(user))
            .to be_empty
        end
      end
    end
  end
end



require 'spec_helper'

describe WorkPackages::UpdateContract do
  let(:work_package) do
    FactoryBot.create(:work_package,
                      done_ratio: 50,
                      estimated_hours: 6.0,
                      project: project)
  end
  let(:member) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  let(:project) { FactoryBot.create(:project) }
  let(:current_user) { member }
  let(:permissions) do
    %i[
      view_work_packages
      view_work_package_watchers
      edit_work_packages
      add_work_package_watchers
      delete_work_package_watchers
      manage_work_package_relations
      add_work_package_notes
    ]
  end
  let(:role) { FactoryBot.create :role, permissions: permissions }
  let(:changed_values) { [] }

  subject(:contract) { described_class.new(work_package, current_user) }

  before do
    allow(work_package).to receive(:changed).and_return(changed_values)
  end

  describe 'story points' do
    context 'has not changed' do
      it('is valid') { expect(contract.errors.empty?).to be true }
    end

    context 'has changed' do
      let(:changed_values) { ['story_points'] }

      it('is valid') { expect(contract.errors.empty?).to be true }
    end
  end

  describe 'remaining hours' do
    context 'is no parent' do
      before do
        contract.validate
      end

      context 'has not changed' do
        it('is valid') { expect(contract.errors.empty?).to be true }
      end

      context 'has changed' do
        let(:changed_values) { ['remaining_hours'] }

        it('is valid') { expect(contract.errors.empty?).to be true }
      end
    end

    context 'is a parent' do
      before do
        child
        work_package.reload
        contract.validate
      end
      let(:child) do
        FactoryBot.create(:work_package, parent_id: work_package.id, project: project)
      end

      context 'has not changed' do
        it('is valid') { expect(contract.errors.empty?).to be true }
      end

      context 'has changed' do
        let(:changed_values) { ['remaining_hours'] }

        it('is invalid') do
          expect(contract.errors.symbols_for(:remaining_hours)).to match_array([:error_readonly])
        end
      end
    end
  end
end



require 'spec_helper'

describe WorkPackage, type: :model do
  let(:work_package) do
    FactoryBot.create(:work_package, project: project,
                                     status: status)
  end
  let(:work_package2) do
    FactoryBot.create(:work_package, project: project2,
                                     status: status)
  end
  let(:user) { FactoryBot.create(:user) }

  let(:type) { FactoryBot.create(:type_standard) }
  let(:project) { FactoryBot.create(:project, types: [type]) }
  let(:project2) { FactoryBot.create(:project, types: [type]) }
  let(:role) { FactoryBot.create(:role) }
  let(:role2) { FactoryBot.create(:role) }
  let(:member) do
    FactoryBot.create(:member, principal: user,
                               roles: [role])
  end
  let(:member2) do
    FactoryBot.create(:member, principal: user,
                               roles: [role2],
                               project: work_package2.project)
  end
  let(:status) { FactoryBot.create(:status) }
  let(:priority) { FactoryBot.create(:priority) }
  let(:cost_type) { FactoryBot.create(:cost_type) }
  let(:cost_entry) do
    FactoryBot.create(:cost_entry, work_package: work_package,
                                   project: work_package.project,
                                   cost_type: cost_type)
  end
  let(:cost_entry2) do
    FactoryBot.create(:cost_entry, work_package: work_package2,
                                   project: work_package2.project,
                                   cost_type: cost_type)
  end

  describe '#cleanup_action_required_before_destructing?' do
    describe 'w/ the work package having a cost entry' do
      before do
        work_package
        cost_entry
      end

      it 'should be true' do
        expect(WorkPackage.cleanup_action_required_before_destructing?(work_package)).to be_truthy
      end
    end

    describe 'w/ two work packages having a cost entry' do
      before do
        work_package
        cost_entry
        cost_entry2
      end

      it 'should be true' do
        expect(WorkPackage.cleanup_action_required_before_destructing?([work_package, work_package2])).to be_truthy
      end
    end

    describe 'w/o the work package having a cost entry' do
      before do
        work_package
      end

      it 'should be false' do
        expect(WorkPackage.cleanup_action_required_before_destructing?(work_package)).to be_falsey
      end
    end
  end

  describe '#associated_classes_to_address_before_destructing?' do
    describe 'w/ the work package having a cost entry' do
      before do
        work_package
        cost_entry
      end

      it "should be have 'CostEntry' as class to address" do
        expect(WorkPackage.associated_classes_to_address_before_destruction_of(work_package)).to eq([CostEntry])
      end
    end

    describe 'w/o the work package having a cost entry' do
      before do
        work_package
      end

      it 'should be empty' do
        expect(WorkPackage.associated_classes_to_address_before_destruction_of(work_package)).to be_empty
      end
    end
  end

  describe '#cleanup_associated_before_destructing_if_required' do
    before do
      work_package.save!

      cost_entry
    end

    describe 'w/o a cleanup being necessary' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'reassign') }

      before do
        cost_entry.destroy
      end

      it 'should return true' do
        expect(action).to be_truthy
      end
    end

    describe 'w/ "destroy" as action' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'destroy') }

      it 'should return true' do
        expect(action).to be_truthy
      end

      it 'should not touch the cost_entry' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package.id)
      end
    end

    describe 'w/o an action' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user) }

      it 'should return true' do
        expect(action).to be_truthy
      end

      it 'should not touch the cost_entry' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package.id)
      end
    end

    describe 'w/ "nullify" as action' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'nullify') }

      it 'should return false' do
        expect(action).to be_falsey
      end

      it 'should not alter the work_package_id of all cost entries' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package.id)
      end

      it 'should set an error on work packages' do
        action

        expect(work_package.errors[:base]).to eq([I18n.t(:'activerecord.errors.models.work_package.nullify_is_not_valid_for_cost_entries')])
      end
    end

    describe 'w/ "reassign" as action
              w/ reassigning to a valid work_package' do
      let(:action) do
        WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'reassign',
                                                                                          reassign_to_id: work_package2.id)
      end

      before do
        work_package2.save!
        role2.add_permission! :edit_cost_entries
        role2.save!
        member2.save!
      end

      it 'should return true' do
        expect(action).to be_truthy
      end

      it 'should set the work_package_id of all cost entries to the new work package' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package2.id)
      end

      it "should set the project_id of all cost entries to the new work package's project" do
        action

        cost_entry.reload
        expect(cost_entry.project_id).to eq(work_package2.project_id)
      end
    end

    describe 'w/ "reassign" as action
              w/ reassigning to a work_package the user is not allowed to see' do
      let(:action) do
        WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'reassign',
                                                                                          reassign_to_id: work_package2.id)
      end

      before do
        work_package2.save!
      end

      it 'should return true' do
        expect(action).to be_falsey
      end

      it 'should not alter the work_package_id of all cost entries' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package.id)
      end
    end

    describe 'w/ "reassign" as action
              w/ reassigning to a non existing work package' do
      let(:action) do
        WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'reassign', reassign_to_id: 0)
      end

      it 'should return true' do
        expect(action).to be_falsey
      end

      it 'should not alter the work_package_id of all cost entries' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package.id)
      end
    end

    describe 'w/ "reassign" as action
              w/o providing a reassignment id' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'reassign') }

      it 'should return true' do
        expect(action).to be_falsey
      end

      it 'should not alter the work_package_id of all cost entries' do
        action

        cost_entry.reload
        expect(cost_entry.work_package_id).to eq(work_package.id)
      end
    end

    describe 'w/ an invalid option' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, action: 'bogus') }

      it 'should return false' do
        expect(action).to be_falsey
      end
    end

    describe 'w/ nil as invalid option' do
      let(:action) { WorkPackage.cleanup_associated_before_destructing_if_required(work_package, user, nil) }

      it 'should return false' do
        expect(action).to be_falsey
      end
    end
  end
end

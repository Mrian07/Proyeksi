

require 'spec_helper'

describe WorkPackages::DeleteService, 'integration', type: :model do
  shared_let(:project) { FactoryBot.create(:project) }
  shared_let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[delete_work_packages view_work_packages add_work_packages manage_subtasks])
  end
  shared_let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end

  describe 'deleting a child with estimated_hours set' do
    let(:parent) { FactoryBot.create(:work_package, project: project) }
    let(:child) do
      FactoryBot.create(:work_package,
                        project: project,
                        parent: parent,
                        estimated_hours: 123)
    end

    let(:instance) do
      described_class.new(user: user,
                          model: child)
    end
    subject { instance.call }

    before do
      # Ensure estimated_hours is inherited
      ::WorkPackages::UpdateAncestorsService.new(user: user, work_package: child).call(%i[estimated_hours])
      parent.reload
    end

    it 'updates the parent estimated_hours' do
      expect(child.estimated_hours).to eq 123
      expect(parent.derived_estimated_hours).to eq 123
      expect(parent.estimated_hours).to eq nil

      expect(subject).to be_success

      parent.reload

      expect(parent.estimated_hours).to eq(nil)
    end
  end

  describe 'with a stale work package reference' do
    let!(:work_package) { FactoryBot.create :work_package, project: project }

    let(:instance) do
      described_class.new(user: user,
                          model: work_package)
    end

    subject { instance.call }

    it 'still destroys it' do
      # Cause lock version changes
      WorkPackage.where(id: work_package.id).update_all(lock_version: work_package.lock_version + 1)

      expect(subject).to be_success
      expect { work_package.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'with a notification' do
    let!(:work_package) { FactoryBot.create :work_package, project: project }
    let!(:notification) do
      FactoryBot.create :notification,
                        recipient: user,
                        actor: user,
                        resource: work_package,
                        project: project
    end

    let(:instance) do
      described_class.new(user: user,
                          model: work_package)
    end

    subject { instance.call }

    it 'deletes the notification' do
      expect(subject).to be_success
      expect { work_package.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { notification.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

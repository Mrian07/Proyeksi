

require 'spec_helper'

describe 'WorkPackage-Visibility', type: :model do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:anonymous) { FactoryBot.create(:anonymous) }
  let(:user) { FactoryBot.create(:user) }
  let(:public_project) { FactoryBot.create(:project, public: true) }
  let(:private_project) { FactoryBot.create(:project, public: false) }
  let(:other_project) { FactoryBot.create(:project, public: true) }
  let(:view_work_packages) { FactoryBot.create(:role, permissions: [:view_work_packages]) }
  let(:view_work_packages_role2) { FactoryBot.create(:role, permissions: [:view_work_packages]) }

  describe 'of public projects' do
    subject { FactoryBot.create(:work_package, project: public_project) }

    it 'is viewable by anonymous, with the view_work_packages permissison' do
      # it is not really clear, where these kind of "preconditions" belong to: This setting
      # is a default in Redmine::DefaultData::Loader - but this not loaded in the tests: here we
      # just make sure, that the workpackage is visible, when this permission is set
      Role.anonymous.add_permission! :view_work_packages
      expect(WorkPackage.visible(anonymous)).to match_array [subject]
    end
  end

  describe 'of private projects' do
    subject { FactoryBot.create(:work_package, project: private_project) }

    it 'is visible for the admin, even if the project is private' do
      expect(WorkPackage.visible(admin)).to match_array [subject]
    end

    it 'is not visible for anonymous users, when the project is private' do
      expect(WorkPackage.visible(anonymous)).to match_array []
    end

    it 'is visible for members of the project, with the view_work_packages permissison' do
      FactoryBot.create(:member,
                        user: user,
                        project: private_project,
                        role_ids: [view_work_packages.id])

      expect(WorkPackage.visible(user)).to match_array [subject]
    end

    it 'is only returned once for members with two roles having view_work_packages permission' do
      subject

      FactoryBot.create(:member,
                        user: user,
                        project: private_project,
                        role_ids: [view_work_packages.id,
                                   view_work_packages_role2.id])

      expect(WorkPackage.visible(user).pluck(:id)).to match_array [subject.id]
    end

    it 'is not visible for non-members of the project without the view_work_packages permissison' do
      expect(WorkPackage.visible(user)).to match_array []
    end

    it 'is not visible for members of the project, without the view_work_packages permissison' do
      no_permission = FactoryBot.create(:role, permissions: [:no_permission])
      FactoryBot.create(:member,
                        user: user,
                        project: private_project,
                        role_ids: [no_permission.id])

      expect(WorkPackage.visible(user)).to match_array []
    end
  end
end

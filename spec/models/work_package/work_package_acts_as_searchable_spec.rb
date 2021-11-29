

require 'spec_helper'

describe WorkPackage, 'acts_as_searchable', type: :model do
  include BecomeMember

  let(:wp_subject) { 'the quick brown fox jumps over the lazy dog' }
  let(:project) do
    FactoryBot.create(:project,
                      public: false)
  end
  let(:work_package) do
    FactoryBot.create(:work_package,
                      subject: wp_subject,
                      project: project)
  end
  let(:user) { FactoryBot.create(:user) }

  describe '#search' do
    describe "w/ the user being logged in
              w/ searching for a matching string
              w/ being member with the appropriate permission" do
      before do
        work_package
        allow(User).to receive(:current).and_return user

        become_member_with_permissions(project, user, :view_work_packages)
      end

      it 'should return the work package' do
        expect(WorkPackage.search(wp_subject.split).first).to include(work_package)
      end
    end

    describe "w/ the user being logged in
              w/ being member with the appropriate permission
              w/ searching for matching string
              w/ searching with an offset" do
      # this offset recreates the way the time is transformed in the controller
      # This will have to be cleaned up
      let(:offset) { (work_package.created_at - 1.minute).strftime('%Y%m%d%H%M%S').to_time }

      before do
        work_package
        allow(User).to receive(:current).and_return user

        become_member_with_permissions(project, user, :view_work_packages)
      end

      it 'should return the work package if the offset is before the work packages created at value' do
        expect(WorkPackage.search(wp_subject.split, nil, offset: offset).first).to include(work_package)
      end
    end
  end
end

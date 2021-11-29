#-- encoding: UTF-8



require 'spec_helper'

describe Versions::Scopes::SharedWith, type: :model do
  shared_let(:root_project) { FactoryBot.create(:project) }
  shared_let(:parent_project) { FactoryBot.create(:project, parent: root_project) }
  shared_let(:project) { FactoryBot.create(:project, parent: parent_project) }
  shared_let(:other_root_project) { FactoryBot.create(:project) }
  shared_let(:aunt_project) { FactoryBot.create(:project, parent: root_project) }
  shared_let(:sibling_project) { FactoryBot.create(:project, parent: parent_project) }
  shared_let(:child_project) { FactoryBot.create(:project, parent: project) }
  shared_let(:grand_child_project) { FactoryBot.create(:project, parent: child_project) }

  describe '.shared_with' do
    context 'with the version not being shared' do
      let!(:version) { FactoryBot.create(:version, project: project, sharing: 'none') }

      it 'is visible within the original project' do
        expect(Version.shared_with(project))
          .to match_array [version]
      end

      it 'is not visible in any other project' do
        [parent_project,
         root_project,
         other_root_project,
         aunt_project,
         sibling_project,
         child_project,
         grand_child_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end
    end

    context 'with the version being shared with descendants' do
      let!(:version) { FactoryBot.create(:version, project: project, sharing: 'descendants') }

      it 'is visible within the original project and it`s descendants' do
        [project,
         child_project,
         grand_child_project].each do |p|
          expect(Version.shared_with(p))
            .to match_array [version]
        end
      end

      it 'is not visible in any other project' do
        [parent_project,
         root_project,
         other_root_project,
         aunt_project,
         sibling_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end

      it 'is not visible in any other project if the project is inactive' do
        project.update(active: false)

        [parent_project,
         root_project,
         child_project,
         grand_child_project,
         aunt_project,
         sibling_project,
         other_root_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end
    end

    context 'with the version being shared with hierarchy' do
      let!(:version) { FactoryBot.create(:version, project: project, sharing: 'hierarchy') }

      it 'is visible within the original project and it`s descendants and ancestors' do
        [project,
         parent_project,
         root_project,
         child_project,
         grand_child_project].each do |p|
          expect(Version.shared_with(p))
            .to match_array [version]
        end
      end

      it 'is not visible in any other project' do
        [other_root_project,
         aunt_project,
         sibling_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end

      it 'is not visible in any other project if the project is inactive' do
        project.update(active: false)

        [parent_project,
         root_project,
         child_project,
         grand_child_project,
         aunt_project,
         sibling_project,
         other_root_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end
    end

    context 'with the version being shared with tree' do
      let(:version) { FactoryBot.create(:version, project: project, sharing: 'tree') }

      it 'is visible within the original project and every project within the same tree' do
        [project,
         parent_project,
         root_project,
         child_project,
         grand_child_project,
         aunt_project,
         sibling_project].each do |p|
          expect(Version.shared_with(p))
            .to match_array [version]
        end
      end

      it 'is not visible projects outside of the tree' do
        [other_root_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end

      it 'is not visible in any other project if the project is inactive' do
        project.update(active: false)

        [parent_project,
         root_project,
         child_project,
         grand_child_project,
         aunt_project,
         sibling_project,
         other_root_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end
    end

    context 'with the version being shared with system' do
      let(:version) { FactoryBot.create(:version, project: project, sharing: 'system') }

      it 'is visible in all projects' do
        [project,
         parent_project,
         root_project,
         child_project,
         grand_child_project,
         aunt_project,
         sibling_project,
         other_root_project].each do |p|
          expect(Version.shared_with(p))
            .to match_array [version]
        end
      end

      it 'is not visible in any other project if the project is inactive' do
        project.update(active: false)

        [parent_project,
         root_project,
         child_project,
         grand_child_project,
         aunt_project,
         sibling_project,
         other_root_project].each do |p|
          expect(Version.shared_with(p))
            .to be_empty
        end
      end
    end
  end
end

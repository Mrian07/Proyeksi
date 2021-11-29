#-- encoding: UTF-8



require 'spec_helper'

describe Versions::Scopes::RolledUp, type: :model do
  shared_let(:parent_project) { FactoryBot.create(:project) }
  shared_let(:project) { FactoryBot.create(:project, parent: parent_project) }
  shared_let(:sibling_project) { FactoryBot.create(:project, parent: parent_project) }
  shared_let(:child_project) { FactoryBot.create(:project, parent: project) }
  shared_let(:grand_child_project) { FactoryBot.create(:project, parent: child_project) }
  shared_let(:version) { FactoryBot.create(:version, project: project) }
  shared_let(:child_version) { FactoryBot.create(:version, project: child_project) }
  shared_let(:grand_child_version) { FactoryBot.create(:version, project: grand_child_project) }
  shared_let(:parent_version) { FactoryBot.create(:version, project: parent_project) }
  shared_let(:sibling_version) { FactoryBot.create(:version, project: sibling_project) }

  describe '.rolled_up' do
    it 'includes versions of self and all descendants' do
      expect(project.rolled_up_versions)
        .to match_array [version, child_version, grand_child_version]
    end

    it 'excludes versions from inactive projects' do
      grand_child_project.update(active: false)

      expect(project.rolled_up_versions)
        .to match_array [version, child_version]
    end
  end
end

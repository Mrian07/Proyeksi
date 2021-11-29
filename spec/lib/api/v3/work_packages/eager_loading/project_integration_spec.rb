#-- encoding: UTF-8

require 'rspec'

require 'spec_helper'
require_relative './eager_loading_mock_wrapper'

describe ::API::V3::WorkPackages::EagerLoading::Project do
  let!(:parent_work_package1) { FactoryBot.create(:work_package, project: parent_project) }
  let!(:work_package1) { FactoryBot.create(:work_package, project: project, parent: parent_work_package1) }
  let!(:work_package2) { FactoryBot.create(:work_package, project: project, parent: parent_work_package1) }
  let!(:child_work_package1) { FactoryBot.create(:work_package, project: child_project, parent: work_package1) }
  let!(:child_work_package2) { FactoryBot.create(:work_package, project: child_project, parent: work_package2) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:parent_project) { FactoryBot.create(:project) }
  let!(:child_project) { FactoryBot.create(:project) }

  describe '.apply' do
    it 'preloads the projects of the work packages, their parents and children' do
      wrapped = EagerLoadingMockWrapper.wrap(described_class, [work_package1, work_package2])

      wrapped.each do |w|
        expect(w.association(:project))
          .to be_loaded

        expect(w.project).to eql project

        expect(w.parent.association(:project))
          .to be_loaded

        expect(w.parent.project).to eql parent_project

        w.children.each do |child|
          expect(child.association(:project))
            .to be_loaded

          expect(child.project).to eql child_project
        end
      end
    end
  end
end



require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkPackage, type: :model do
  let(:user) { FactoryBot.create(:admin) }
  let(:role) { FactoryBot.create(:role) }
  let(:project) do
    FactoryBot.create(:project_with_types, members: { user => role })
  end

  let(:project2) { FactoryBot.create(:project_with_types, types: project.types) }
  let(:work_package) do
    FactoryBot.create(:work_package, project: project,
                                     type: project.types.first,
                                     author: user)
  end
  let!(:cost_entry) do
    FactoryBot.create(:cost_entry, work_package: work_package, project: project, units: 3, spent_on: Date.today, user: user,
                                   comments: 'test entry')
  end
  let!(:budget) { FactoryBot.create(:budget, project: project) }

  def move_to_project(work_package, project)
    service = WorkPackages::MoveService.new(work_package, user)

    service.call(project)
  end

  it 'should update cost entries on move' do
    expect(work_package.project_id).to eql project.id
    expect(move_to_project(work_package, project2)).not_to be_falsey
    expect(cost_entry.reload.project_id).to eql project2.id
  end

  it 'should allow to set budget to nil' do
    work_package.budget = budget
    work_package.save!
    expect(work_package.budget).to eql budget

    work_package.reload
    work_package.budget = nil
    expect { work_package.save! }.not_to raise_error
  end
end

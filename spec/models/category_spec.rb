

require 'spec_helper'

describe Category, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:created_category) { FactoryBot.create(:category, project: project, assigned_to: assignee) }
  let(:assignee) { nil }

  describe '#create' do
    it 'is creatable and takes the attributes' do
      category = described_class.create project: project, name: 'New category'

      expect(category.attributes.slice('project_id', 'name'))
        .to eq('project_id' => project.id, 'name' => 'New category')
    end

    context 'with a group assignment' do
      let(:group) do
        FactoryBot.create(:group,
                          member_in_project: project,
                          member_with_permissions: [])
      end
      let(:assignee) { group }

      it 'allows to assign groups' do
        expect(created_category.assigned_to)
          .to eq group
      end
    end
  end

  describe '#destroy' do
    let!(:work_package) { FactoryBot.create(:work_package, project: project, category: created_category) }

    it 'nullifies existing assignments to a work package' do
      created_category.destroy

      expect(work_package.reload.category_id)
        .to be_nil
    end

    it 'allows reassigning to a different category' do
      other_category = FactoryBot.create(:category, project: project)

      created_category.destroy(other_category)

      expect(work_package.reload.category)
        .to eq other_category
    end
  end
end

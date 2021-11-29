

require 'spec_helper'

describe WorkPackage::Ancestors, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create :project }
  let(:project2) { FactoryBot.create :project }

  let!(:root_work_package) do
    FactoryBot.create :work_package,
                      project: project
  end

  let!(:intermediate) do
    FactoryBot.create :work_package,
                      parent: root_work_package,
                      project: project
  end
  let!(:intermediate_project2) do
    FactoryBot.create :work_package,
                      parent: root_work_package,
                      project: project2
  end
  let!(:leaf) do
    FactoryBot.create :work_package,
                      parent: intermediate,
                      project: project
  end
  let!(:leaf_project2) do
    FactoryBot.create :work_package,
                      parent: intermediate_project2,
                      project: project
  end

  let(:view_role) do
    FactoryBot.build(:role,
                     permissions: [:view_work_packages])
  end

  let(:none_role) do
    FactoryBot.build(:role,
                     permissions: [])
  end

  let(:leaf_ids) { [leaf.id, leaf_project2.id] }
  let(:intermediate_ids) { [intermediate.id, intermediate_project2.id] }

  subject { ::WorkPackage.aggregate_ancestors(ids, user) }

  before do
    allow(Setting).to receive(:cross_project_work_package_relations?).and_return(true)
    login_as(user)
  end

  context 'with permission in the first project' do
    before do
      FactoryBot.create :member,
                        user: user,
                        project: project,
                        roles: [view_role]
    end

    describe 'fetching from db' do
      it 'returns the same results' do
        expect(leaf.visible_ancestors(user)).to eq([root_work_package, intermediate])
      end
    end

    describe 'leaf ids' do
      let(:ids) { leaf_ids }

      it 'returns ancestors for the leaf in project 1' do
        expect(subject).to be_kind_of(Hash)
        expect(subject.keys.length).to eq(2)

        expect(subject[leaf.id]).to eq([root_work_package, intermediate])
        expect(subject[leaf_project2.id]).to eq([root_work_package])
      end
    end

    describe 'intermediate ids' do
      let(:ids) { intermediate_ids }

      it 'returns all ancestors in project 1' do
        expect(subject).to be_kind_of(Hash)
        expect(subject.keys.length).to eq(2)

        expect(subject[intermediate.id]).to eq([root_work_package])
        expect(subject[intermediate_project2.id]).to eq([root_work_package])
      end
    end

    context 'and permission in second project' do
      before do
        FactoryBot.create :member,
                          user: user,
                          project: project2,
                          roles: [view_role]
      end

      describe 'leaf ids' do
        let(:ids) { leaf_ids }

        it 'returns all ancestors' do
          expect(subject).to be_kind_of(Hash)
          expect(subject.keys.length).to eq(2)

          expect(subject[leaf.id]).to eq([root_work_package, intermediate])
          expect(subject[leaf_project2.id]).to eq([root_work_package, intermediate_project2])
        end
      end
    end
  end

  context 'no permissions' do
    before do
      FactoryBot.create :member,
                        user: user,
                        project: project,
                        roles: [none_role]
    end

    describe 'leaf ids' do
      let(:ids) { leaf_ids }

      it 'returns no results for all ids' do
        expect(subject).to be_kind_of(Hash)
        expect(subject.keys.length).to eq(0)
      end
    end
  end
end

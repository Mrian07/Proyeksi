

require 'spec_helper'

describe Query, "manual sorting ", type: :model do
  shared_let(:user) { FactoryBot.create :admin }
  shared_let(:project) { FactoryBot.create :project }
  shared_let(:query) { FactoryBot.create :query, user: user, project: project }
  shared_let(:wp_1) do
    User.execute_as user do
      FactoryBot.create :work_package, project: project
    end
  end
  shared_let(:wp_2) do
    User.execute_as user do
      FactoryBot.create :work_package, project: project
    end
  end

  before do
    login_as user
  end

  describe '#ordered_work_packages' do
    it 'keeps the current set of ordered work packages' do
      expect(query.ordered_work_packages).to eq []

      expect(::OrderedWorkPackage.where(query_id: query.id).count).to eq 0

      query.ordered_work_packages.build(work_package_id: wp_1.id, position: 0)
      query.ordered_work_packages.build(work_package_id: wp_2.id, position: 1)

      expect(::OrderedWorkPackage.where(query_id: query.id).count).to eq 0
      expect(query.save).to eq true
      expect(::OrderedWorkPackage.where(query_id: query.id).count).to eq 2

      query.reload
      expect(query.ordered_work_packages.pluck(:work_package_id)).to eq [wp_1.id, wp_2.id]
    end
  end

  describe 'with a second query on the same work package' do
    let(:query2) { FactoryBot.create :query, user: user, project: project }

    before do
      ::OrderedWorkPackage.create(query: query, work_package: wp_1, position: 0)
      ::OrderedWorkPackage.create(query: query, work_package: wp_2, position: 1)

      ::OrderedWorkPackage.create(query: query2, work_package: wp_1, position: 4)
      ::OrderedWorkPackage.create(query: query2, work_package: wp_2, position: 3)
    end

    it 'returns the correct number of work packages' do
      query.add_filter('manual_sort', 'ow', [])
      query2.add_filter('manual_sort', 'ow', [])

      query.sort_criteria = [[:manual_sorting, 'asc']]
      query2.sort_criteria = [[:manual_sorting, 'asc']]

      expect(query.results.work_packages.pluck(:id)).to eq [wp_1.id, wp_2.id]
      expect(query2.results.work_packages.pluck(:id)).to eq [wp_2.id, wp_1.id]
    end
  end
end

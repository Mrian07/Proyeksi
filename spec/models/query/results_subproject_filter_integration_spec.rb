

require 'spec_helper'

describe ::Query::Results, 'Subproject filter integration', type: :model, with_mail: false do
  let(:query) do
    FactoryBot.build(:query,
                     user: user,
                     project: parent_project).tap do |q|
      q.filters.clear
    end
  end
  let(:query_results) do
    ::Query::Results.new query
  end

  shared_let(:parent_project) { FactoryBot.create :project }
  shared_let(:child_project) { FactoryBot.create :project, parent: parent_project }

  shared_let(:user) do
    FactoryBot.create(:user,
                      firstname: 'user',
                      lastname: '1',
                      member_in_projects: [parent_project, child_project],
                      member_with_permissions: [:view_work_packages])
  end

  shared_let(:parent_wp) { FactoryBot.create :work_package, project: parent_project }
  shared_let(:child_wp) { FactoryBot.create :work_package, project: child_project }

  before do
    login_as user
  end

  context 'when subprojects included', with_settings: { display_subprojects_work_packages: true } do
    it 'shows the sub work packages' do
      expect(query_results.work_packages).to match_array [parent_wp, child_wp]
    end
  end

  context 'when subprojects not included', with_settings: { display_subprojects_work_packages: false } do
    it 'does not show the sub work packages' do
      expect(query_results.work_packages).to match_array [parent_wp]
    end

    context 'when subproject filter added manually' do
      before do
        query.add_filter('subproject_id', '=', [child_project.id])
      end

      it 'shows the sub work packages' do
        expect(query_results.work_packages).to match_array [parent_wp, child_wp]
      end
    end

    context 'when only subproject filter added manually' do
      before do
        query.add_filter('only_subproject_id', '=', [child_project.id])
      end

      it 'shows only the sub work packages' do
        expect(query_results.work_packages).to match_array [child_wp]
      end
    end
  end
end



require 'spec_helper'

RSpec.feature 'Work package pagination', js: true do
  shared_let(:admin) { FactoryBot.create :admin }

  let(:project) do
    FactoryBot.create(:project, name: 'project1', identifier: 'project1')
  end

  shared_examples_for 'paginated work package list' do
    let!(:work_package_1) { FactoryBot.create(:work_package, project: project) }
    let!(:work_package_2) { FactoryBot.create(:work_package, project: project) }

    before do
      login_as(admin)
      allow(Setting).to receive(:per_page_options).and_return '1, 50, 100'

      visit path
      expect(current_path).to eq(expected_path)
    end

    scenario do
      expect(page).to have_content('All open')

      within('.work-packages-partitioned-query-space--container') do
        expect(page).to     have_content(work_package_1.subject)
        expect(page).to_not have_content(work_package_2.subject)
      end

      within('.op-pagination--pages') do
        find('.op-pagination--item button', text: '2').click
      end

      within('.work-packages-partitioned-query-space--container') do
        expect(page).to     have_content(work_package_2.subject)
        expect(page).to_not have_content(work_package_1.subject)
      end

      within('.op-pagination--options') do
        find('.op-pagination--item button', text: '50').click
      end

      within('.work-packages-partitioned-query-space--container') do
        expect(page).to have_content(work_package_1.subject)
        expect(page).to have_content(work_package_2.subject)
      end
    end
  end

  context 'with project scope' do
    it_behaves_like 'paginated work package list' do
      let(:path) { project_work_packages_path(project) }
      let(:expected_path) { '/projects/project1/work_packages' }
    end
  end

  context 'globally' do
    it_behaves_like 'paginated work package list' do
      let(:path) { work_packages_path }
      let(:expected_path) { '/work_packages' }
    end
  end
end

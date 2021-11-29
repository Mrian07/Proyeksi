

require 'spec_helper'

describe 'Work package filtering by subject', js: true do
  let(:project) { FactoryBot.create :project, public: true }
  let(:admin) { FactoryBot.create :admin }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }

  let!(:wp_match) { FactoryBot.create :work_package, project: project, subject: 'R#1234 Foobar' }
  let!(:wp_nomatch) { FactoryBot.create :work_package, project: project, subject: 'R!1234 Foobar' }

  before do
    login_as admin
  end

  it 'shows the one work package filtering for myself' do
    wp_table.visit!
    wp_table.expect_work_package_listed(wp_match, wp_nomatch)

    # Add and save query with me filter
    filters.open
    filters.remove_filter 'status'
    filters.add_filter_by('Subject', 'contains', ['R#'])

    wp_table.ensure_work_package_not_listed!(wp_nomatch)
    wp_table.expect_work_package_listed(wp_match)

    wp_table.save_as('Subject query')
    loading_indicator_saveguard

    # Expect correct while saving
    wp_table.expect_title 'Subject query'
    query = Query.last
    expect(query.filters.first.values).to eq ['R#']
    filters.expect_filter_by('Subject', 'contains', ['R#'])

    # Revisit query
    wp_table.visit_query query
    wp_table.ensure_work_package_not_listed!(wp_nomatch)
    wp_table.expect_work_package_listed(wp_match)

    filters.open
    filters.expect_filter_by('Subject', 'contains', ['R#'])
  end
end



require 'spec_helper'

RSpec.feature 'Work package timeline date formatting',
              with_settings: { date_format: '%Y-%m-%d' },
              js: true,
              selenium: true do
  shared_let(:type) { FactoryBot.create(:type_bug) }
  shared_let(:project) { FactoryBot.create(:project, types: [type]) }

  shared_let(:work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      start_date: '2020-12-31',
                      due_date: '2021-01-01',
                      subject: 'My subject'
  end

  let(:wp_timeline) { Pages::WorkPackagesTimeline.new(project) }
  let!(:query_tl) do
    query = FactoryBot.build(:query, user: current_user, project: project)
    query.column_names = ['id', 'type', 'subject']
    query.filters.clear
    query.timeline_visible = true
    query.timeline_zoom_level = 'days'
    query.name = 'Query with Timeline'

    query.save!
    query
  end

  def expect_date_week(date, expected_week)
    week = page.evaluate_script <<~JS
      moment('#{date}').format('ww');
    JS

    expect(week).to eq(expected_week)
  end

  before do
    login_as current_user

    wp_timeline.visit_query query_tl
  end

  describe 'with default settings',
           with_settings: { start_of_week: '', first_week_of_year: '' } do

    context 'with english locale user' do
      let(:current_user) { FactoryBot.create :admin, language: 'en' }

      it 'shows english ISO dates' do
        # expect moment to return week 01 for start date
        expect_date_week work_package.start_date.iso8601, '01'
        expect_date_week work_package.due_date.iso8601, '01'
        # Monday, 4th of january is the second week
        expect_date_week '2021-01-04', '02'
      end
    end

    context 'with german locale user' do
      let(:current_user) { FactoryBot.create :admin, language: 'de' }

      it 'shows german ISO dates' do
        expect(page).to have_selector('.wp-timeline--header-element', text: '52')
        expect(page).to have_selector('.wp-timeline--header-element', text: '53')

        # expect moment to return week 53 for start date
        expect_date_week work_package.start_date.iso8601, '53'
        expect_date_week work_package.due_date.iso8601, '53'
        # Monday, 4th of january is the first week
        expect_date_week '2021-01-04', '01'
      end
    end
  end

  describe 'with US/CA settings',
           with_settings: { start_of_week: '7', first_week_of_year: '1' } do

    let(:current_user) { FactoryBot.create :admin }

    it 'shows english ISO dates' do
      expect(page).to have_selector('.wp-timeline--header-element', text: '01')
      expect(page).to have_selector('.wp-timeline--header-element', text: '02')
      expect(page).to have_no_selector('.wp-timeline--header-element', text: '53')

      # expect moment to return week 01 for start date and due date
      expect_date_week work_package.start_date.iso8601, '01'
      expect_date_week work_package.due_date.iso8601, '01'
      # First sunday in january is in second week
      expect_date_week '2021-01-03', '02'
    end
  end
end

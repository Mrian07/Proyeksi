

require 'spec_helper'

describe 'Meeting search', type: :feature, js: true do
  include ::Components::NgSelectAutocompleteHelpers
  let(:project) { FactoryBot.create :project }
  let(:user) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  let(:role) { FactoryBot.create :role, permissions: %i(view_meetings view_work_packages) }

  let!(:meeting) { FactoryBot.create(:meeting, project: project) }

  before do
    login_as user

    visit project_path(project)
  end

  context 'global search' do
    it 'works' do
      select_autocomplete(page.find('.top-menu-search--input'),
                          query: "Meeting",
                          select_text: "In this project ↵")

      page.find('[data-qa-tab-id="meetings"]').click
      expect(page.find('#search-results')).to have_text(meeting.title)
    end
  end
end

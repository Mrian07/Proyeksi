

require 'spec_helper'

describe 'Workflow copy', type: :feature do
  let(:role) { FactoryBot.create(:role) }
  let(:type) { FactoryBot.create(:type) }
  let(:admin)  { FactoryBot.create(:admin) }
  let(:statuses) { (1..2).map { |_i| FactoryBot.create(:status) } }
  let(:workflow) do
    FactoryBot.create(:workflow, role_id: role.id,
                                 type_id: type.id,
                                 old_status_id: statuses[0].id,
                                 new_status_id: statuses[1].id,
                                 author: false,
                                 assignee: false)
  end

  before do
    allow(User).to receive(:current).and_return(admin)
  end

  context 'lala' do
    before do
      workflow.save
      visit url_for(controller: '/workflows', action: :copy)
    end

    it 'shows existing types and roles' do
      select(role.name, from: :source_role_id)
      within('#source_role_id') do
        expect(page).to have_content(role.name)
        expect(page).to have_content("--- #{I18n.t(:actionview_instancetag_blank_option)} ---")
      end
      within('#source_type_id') do
        expect(page).to have_content(type.name)
        expect(page).to have_content("--- #{I18n.t(:actionview_instancetag_blank_option)} ---")
      end
    end
  end
end

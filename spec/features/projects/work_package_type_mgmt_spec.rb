

require 'spec_helper'

describe 'Projects', 'work package type mgmt', type: :feature, js: true do
  current_user { FactoryBot.create(:user, member_in_project: project, member_with_permissions: %i[edit_project manage_types]) }

  let(:phase_type)     { FactoryBot.create(:type, name: 'Phase', is_default: true) }
  let(:milestone_type) { FactoryBot.create(:type, name: 'Milestone', is_default: false) }
  let!(:project) { FactoryBot.create(:project, name: 'Foo project', types: [phase_type, milestone_type]) }

  it "have the correct types checked for the project's types" do
    visit projects_path
    click_on 'Foo project'
    click_on 'Project settings'
    click_on 'Work package types'

    expect(find_field('Phase', visible: false)['checked'])
      .to be_truthy

    expect(find_field('Milestone', visible: false)['checked'])
      .to be_truthy

    # Disable a type
    find_field('Milestone', visible: false).click

    click_button 'Save'

    expect(find_field('Milestone', visible: false)['checked'])
      .to be_falsey
  end
end

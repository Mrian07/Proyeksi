

require 'spec_helper'

describe 'Wysiwyg work package user mentions',
         type: :feature,
         js: true do
  let!(:user) { FactoryBot.create :admin }
  let!(:user2) { FactoryBot.create(:user, firstname: 'Foo', lastname: 'Bar', member_in_project: project) }
  let!(:group) { FactoryBot.create(:group, firstname: 'Foogroup', lastname: 'Foogroup') }
  let!(:group_role) { FactoryBot.create(:role) }
  let!(:group_member) do
    FactoryBot.create(:member,
                      principal: group,
                      project: project,
                      roles: [group_role])
  end
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[work_package_tracking]) }
  let!(:work_package) do
    User.execute_as user do
      FactoryBot.create(:work_package, subject: 'Foobar', project: project)
    end
  end

  let(:wp_page) { ::Pages::FullWorkPackage.new work_package, project }
  let(:editor) { ::Components::WysiwygEditor.new }

  let(:selector) { '.work-packages--activity--add-comment' }
  let(:comment_field) do
    TextEditorField.new wp_page,
                        'comment',
                        selector: selector
  end

  before do
    login_as(user)
    wp_page.visit!
    wp_page.ensure_page_loaded
  end

  it 'can autocomplete users and groups' do
    # Mentioning a user works
    comment_field.activate!

    comment_field.clear with_backspace: true
    comment_field.input_element.send_keys("@Foo")
    expect(page).to have_selector('.mention-list-item', text: user2.name)
    expect(page).to have_selector('.mention-list-item', text: group.name)

    page.find('.mention-list-item', text: user2.name).click

    expect(page)
      .to have_selector('a.mention', text: '@Foo Bar')

    comment_field.submit_by_click if comment_field.active?

    wp_page.expect_and_dismiss_toaster message: "The comment was successfully added."

    expect(page)
      .to have_selector('a.user-mention', text: 'Foo Bar')

    # Mentioning a group works
    comment_field.activate!
    comment_field.clear with_backspace: true
    comment_field.input_element.send_keys(" @Foo")
    expect(page).to have_selector('.mention-list-item', text: user2.name)
    expect(page).to have_selector('.mention-list-item', text: group.name)

    page.find('.mention-list-item', text: group.name).click

    expect(page)
      .to have_selector('a.mention', text: '@Foogroup')

    comment_field.submit_by_click if comment_field.active?

    wp_page.expect_and_dismiss_toaster message: "The comment was successfully added."

    expect(page)
      .to have_selector('a.user-mention', text: 'Foogroup')

    # The mention is still displayed as such when reentering the comment field
    find('#activity-1 .op-user-activity')
      .hover

    within('#activity-1') do
      click_button("Edit this comment")
    end

    expect(page)
      .to have_selector('a.mention', text: '@Foo Bar')
  end
end

#-- encoding: UTF-8



require 'spec_helper'
require 'features/page_objects/notification'

describe 'Upload attachment to budget', js: true do
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %i[view_budgets
                                                  edit_budgets]
  end
  let(:project) { FactoryBot.create(:project) }
  let(:attachments) { ::Components::Attachments.new }
  let(:image_fixture) { ::UploadedFile.load_from('spec/fixtures/files/image.png') }
  let(:editor) { ::Components::WysiwygEditor.new }

  before do
    login_as(user)
  end

  it 'can upload an image to new and existing budgets via drag & drop' do
    visit projects_budgets_path(project)

    within '.toolbar-items' do
      click_on "Budget"
    end

    fill_in "Subject", with: 'New budget'

    # adding an image
    editor.drag_attachment image_fixture.path, 'Image uploaded on creation'

    expect(page).to have_selector('attachment-list-item', text: 'image.png')

    click_on 'Create'

    expect(page).to have_selector('#content img', count: 1)
    expect(page).to have_content('Image uploaded on creation')
    expect(page).to have_selector('attachment-list-item', text: 'image.png')

    within '.toolbar-items' do
      click_on "Update"
    end

    editor.drag_attachment image_fixture.path, 'Image uploaded the second time'

    expect(page).to have_selector('attachment-list-item', text: 'image.png', count: 2)

    click_on 'Submit'

    expect(page).to have_selector('#content img', count: 2)
    expect(page).to have_content('Image uploaded on creation')
    expect(page).to have_content('Image uploaded the second time')
    expect(page).to have_selector('attachment-list-item', text: 'image.png', count: 2)
  end
end

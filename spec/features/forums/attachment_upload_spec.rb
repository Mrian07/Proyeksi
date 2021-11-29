#-- encoding: UTF-8



require 'spec_helper'
require 'features/page_objects/notification'

describe 'Upload attachment to forum message', js: true do
  let(:forum) { FactoryBot.create(:forum) }
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %i[view_messages
                                                  add_messages
                                                  edit_messages]
  end
  let(:project) { forum.project }
  let(:attachments) { ::Components::Attachments.new }
  let(:image_fixture) { UploadedFile.load_from('spec/fixtures/files/image.png') }
  let(:editor) { ::Components::WysiwygEditor.new }
  let(:index_page) { Pages::Messages::Index.new(forum.project) }

  before do
    login_as(user)
  end

  it 'can upload an image to new and existing messages via drag & drop' do
    index_page.visit!
    click_link forum.name

    create_page = index_page.click_create_message
    create_page.set_subject 'A new message'

    # adding an image
    editor.drag_attachment image_fixture.path, 'Image uploaded on creation'

    expect(page).to have_selector('attachment-list-item', text: 'image.png')
    expect(page).not_to have_selector('op-toasters-upload-progress')

    show_page = create_page.click_save

    expect(page).to have_selector('#content .wiki img', count: 1)
    expect(page).to have_content('Image uploaded on creation')
    expect(page).to have_selector('attachment-list-item', text: 'image.png')

    within '.toolbar-items' do
      click_on "Edit"
    end

    find('.op-uc-figure').click
    find('.ck-widget__type-around__button_after').click

    editor.type_slowly("A spacer text")

    editor.drag_attachment image_fixture.path, 'Image uploaded the second time'

    expect(page).to have_selector('attachment-list-item', text: 'image.png', count: 2)
    expect(page).not_to have_selector('op-toasters-upload-progress')

    show_page.click_save

    expect(page).to have_selector('#content .wiki img', count: 2)
    expect(page).to have_content('Image uploaded on creation')
    expect(page).to have_content('Image uploaded the second time')

    expect(page).to have_selector('attachment-list-item', text: 'image.png', count: 2)
  end
end

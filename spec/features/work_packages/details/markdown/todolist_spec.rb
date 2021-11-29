

require 'spec_helper'

describe 'Todolists in CKEditor', js: true do
  let(:user) { FactoryBot.create :admin }

  before do
    login_as user
  end

  describe 'with an existing work package' do
    let(:work_package) { FactoryBot.create :work_package }
    let(:wp_page) { ::Pages::FullWorkPackage.new(work_package) }
    let(:field) { wp_page.edit_field :description }
    let(:ckeditor) { field.ckeditor }

    it 'can add task list and edit them again' do
      wp_page.visit!
      wp_page.ensure_page_loaded

      field.activate!
      ckeditor.clear

      ckeditor.click_toolbar_button 'To-do List'
      ckeditor.type_slowly 'Todo item 1'
      ckeditor.type_slowly :enter
      ckeditor.type_slowly 'Todo item 2'
      ckeditor.type_slowly :enter

      # Indent
      ckeditor.type_slowly :tab
      ckeditor.type_slowly 'Nested item 1'

      ckeditor.type_slowly :enter
      ckeditor.type_slowly 'Nested item 2'
      ckeditor.type_slowly :enter

      # Outdent
      ckeditor.type_slowly %i[shift tab]
      ckeditor.type_slowly 'Todo item 3'

      # Select first and first nested item
      ckeditor.in_editor do |_container, editable|
        first_item = editable.all('.op-uc-list li')[0]
        first_item.find('input[type=checkbox]', visible: :all).set true

        # First nested
        first_nested_item = editable.all('.op-uc-list .op-uc-list li')[0]
        first_nested_item.find('input[type=checkbox]', visible: :all).set true

        sleep 0.5
      end

      field.submit_by_click

      wp_page.expect_and_dismiss_toaster message: 'Successful update.'

      within(field.display_element) do
        expect(page).to have_selector('.op-uc-list--task-checkbox', count: 5)
        expect(page).to have_selector('.op-uc-list--task-checkbox[checked]', count: 2)

        expect(page).to have_selector('.op-uc-list--item', text: 'Todo item 1')
        expect(page).to have_selector('.op-uc-list--item', text: 'Todo item 2')
        expect(page).to have_selector('.op-uc-list--item', text: 'Todo item 3')

        expect(page).to have_selector('.op-uc-list .op-uc-list .op-uc-list--item', text: 'Nested item 1')
        expect(page).to have_selector('.op-uc-list .op-uc-list .op-uc-list--item', text: 'Nested item 2')

        first_item = page.find('.op-uc-list--item', text: 'Todo item 1')
        expect(first_item).to have_selector('.op-uc-list--task-checkbox[checked]')
        first_nested_item = page.find('.op-uc-list .op-uc-list .op-uc-list--item', text: 'Nested item 1')
        expect(first_nested_item).to have_selector('.op-uc-list--task-checkbox[checked]')
      end

      # Expect still the same when editing again
      field.activate!
      ckeditor.in_editor do |_container, editable|
        expect(editable).to have_selector('.op-uc-list li', count: 5)

        first_item = editable.all('.op-uc-list li')[0].find('input[type=checkbox]', visible: :all)
        expect(first_item).to be_checked

        # First nested
        first_nested_item = editable.all('.op-uc-list .op-uc-list li')[0].find('input[type=checkbox]', visible: :all)
        expect(first_nested_item).to be_checked

        # Check last item
        last_item = editable.all('.op-uc-list li').last
        last_item.find('input[type=checkbox]', visible: :all).set true

        sleep 0.5
      end

      field.submit_by_click
      wp_page.expect_and_dismiss_toaster message: 'Successful update.'

      within(field.display_element) do
        expect(page).to have_selector('.op-uc-list--task-checkbox', count: 5)
        expect(page).to have_selector('.op-uc-list--task-checkbox[checked]', count: 3)

        first_item = page.find('.op-uc-list--item', text: 'Todo item 1')
        expect(first_item).to have_selector('.op-uc-list--task-checkbox[checked]')
        first_nested_item = page.find('.op-uc-list .op-uc-list .op-uc-list--item', text: 'Nested item 1')
        expect(first_nested_item).to have_selector('.op-uc-list--task-checkbox[checked]')

        last_item = page.find('.op-uc-list .op-uc-list--item', text: 'Todo item 3')
        expect(last_item).to have_selector('.op-uc-list--task-checkbox[checked]')
      end
    end
  end

  describe 'creating a new work package' do
    let!(:status) { FactoryBot.create :default_status }
    let!(:priority) { FactoryBot.create :default_priority }
    let!(:type) { FactoryBot.create :type_task }
    let(:project) { FactoryBot.create :project, types: [type] }
    let(:wp_page) { ::Pages::FullWorkPackageCreate.new project: project }
    let(:field) { wp_page.edit_field :description }
    let(:ckeditor) { field.ckeditor }

    before do
      wp_page.visit!

      wp_page.edit_field(:subject).set_value 'Title'

      field.expect_active!
      ckeditor.clear
    end

    it 'can add a task list with links in them (Regression #30920)' do
      ckeditor.click_toolbar_button 'To-do List'
      ckeditor.type_slowly 'Todo item 1'
      ckeditor.type_slowly :enter
      ckeditor.insert_link 'https://community.openproject.com'
      ckeditor.type_slowly :enter
      ckeditor.type_slowly :tab
      ckeditor.insert_link 'https://community.openproject.com/nested'

      # Update the link text, no idea how to do this differently
      ckeditor.in_editor do |_container, editable|
        link = editable.find('.op-uc-list .op-uc-list a')
        link.set('This is a link')

        sleep 0.5
      end

      # Select nested item
      ckeditor.in_editor do |_container, editable|
        editable.find('.op-uc-list .op-uc-list input[type=checkbox]', visible: :all).set true

        sleep 0.5
      end

      wp_page.save!
      wp_page.expect_and_dismiss_toaster message: 'Successful creation.'

      expect(page).to have_selector('.op-uc-list--task-checkbox', count: 3)
      expect(page).to have_selector('.op-uc-list--task-checkbox[checked]', count: 1)

      expect(page).to have_selector('.op-uc-list--item a[href="https://community.openproject.com/"]')
      nested_link = page.find('.op-uc-list--item .op-uc-list--item a[href="https://community.openproject.com/nested"]')
      expect(nested_link.text).to eq 'This is a link'

      description = WorkPackage.last.description
      expected = <<~EOS
        *   [ ] Todo item 1
        *   [ ] [https://community.openproject.com](https://community.openproject.com/)
            *   [x] [This is a link](https://community.openproject.com/nested)
      EOS

      expect(description.strip).to eq expected.strip
    end

    it 'can add task list and edit them again' do
      ckeditor.click_toolbar_button 'To-do List'
      ckeditor.type_slowly 'Todo item 1'
      ckeditor.type_slowly :enter
      ckeditor.type_slowly 'Todo item 2'

      # Select first item
      ckeditor.in_editor do |_container, editable|
        first_item = editable.all('.op-uc-list li')[0]
        first_item.find('input[type=checkbox]', visible: :all).set true

        sleep 0.5
      end

      wp_page.save!
      wp_page.expect_and_dismiss_toaster message: 'Successful creation.'

      within(field.display_element) do
        expect(page).to have_selector('.op-uc-list--task-checkbox', count: 2)
        expect(page).to have_selector('.op-uc-list--task-checkbox[checked]', count: 1)

        expect(page).to have_selector('.op-uc-list--item', text: 'Todo item 1')
        expect(page).to have_selector('.op-uc-list--item', text: 'Todo item 2')

        first_item = page.find('.op-uc-list--item', text: 'Todo item 1')
        expect(first_item).to have_selector('.op-uc-list--task-checkbox[checked]')
      end

      # Expect still the same when editing again
      field.activate!
      ckeditor.in_editor do |_container, editable|
        expect(editable).to have_selector('.op-uc-list li', count: 2)

        first_item = editable.all('.op-uc-list li')[0].find('input[type=checkbox]', visible: :all)
        expect(first_item).to be_checked

        # Check last item
        last_item = editable.all('.op-uc-list li').last
        last_item.find('input[type=checkbox]', visible: :all).set true

        sleep 0.5
      end

      field.submit_by_click
      wp_page.expect_and_dismiss_toaster message: 'Successful update.'

      within(field.display_element) do
        expect(page).to have_selector('.op-uc-list--task-checkbox', count: 2)
        expect(page).to have_selector('.op-uc-list--task-checkbox[checked]', count: 2)

        first_item = page.find('.op-uc-list--item', text: 'Todo item 1')
        expect(first_item).to have_selector('.op-uc-list--task-checkbox[checked]')

        last_item = page.find('.op-uc-list .op-uc-list--item', text: 'Todo item 2')
        expect(last_item).to have_selector('.op-uc-list--task-checkbox[checked]')
      end
    end
  end
end

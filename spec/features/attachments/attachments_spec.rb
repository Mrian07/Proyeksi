

require 'spec_helper'

describe 'attachments', type: :feature do
  let(:project) { FactoryBot.create :valid_project }
  let(:current_user) { FactoryBot.create :admin }
  let!(:priority) { FactoryBot.create :default_priority }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  describe 'upload', js: true do
    let(:file) { FactoryBot.create :file, name: 'textfile.txt' }

    # FIXME rework this spec after implementing fullscreen create view
    xit 'uploading a short text file and viewing it inline' do
      visit new_project_work_packages_path(project)

      select project.types.first.name, from: 'work_package_type_id'
      fill_in 'Subject', with: 'attachment test'

      # open attachment fieldset and attach file
      attach_file 'attachments[1][file]', file.path

      click_button 'Create'

      file_name = File.basename file.path

      expect(page).to have_text('Successful creation.')
      expect(page).to have_text(file_name)
    end
  end
end

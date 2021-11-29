

require 'spec_helper'

describe 'creating a child directly after the wp itself was created', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project, types: [type]) }
  let(:wp_page) { Pages::FullWorkPackageCreate.new }

  let!(:status) { FactoryBot.create(:status, is_default: true) }
  let!(:priority) { FactoryBot.create(:priority, is_default: true) }
  let(:type) { FactoryBot.create(:type, custom_fields: [custom_field]) }
  let(:custom_field) do
    FactoryBot.create :work_package_custom_field,
                      field_format: 'int',
                      is_for_all: true
  end
  let(:relations_tab) { find('.op-tab-row--link', text: 'RELATIONS') }

  before do
    login_as user
    visit new_project_work_packages_path(project.identifier, type: type.id)
    expect_angular_frontend_initialized
    loading_indicator_saveguard
  end

  it 'keeps its custom field values (regression #29511, #29446)' do
    # Set subject
    subject = wp_page.edit_field :subject
    subject.set_value 'My subject'

    # Set CF
    cf = wp_page.edit_field "customField#{custom_field.id}"
    cf.set_value '42'

    # Save WP
    wp_page.save!
    wp_page.expect_and_dismiss_toaster(message: 'Successful creation.')

    # Add child
    scroll_to_and_click relations_tab
    find('.wp-inline-create--add-link.wp-inline-create--split-link').click
    fill_in 'wp-new-inline-edit--field-subject', with: 'A child WP'
    find('#wp-new-inline-edit--field-subject').native.send_keys(:return)

    # Expect CF value to be still visible
    wp_page.expect_and_dismiss_toaster(message: 'Successful creation.')
    expect(wp_page).to have_selector('[data-qa-selector="tab-count"]', text: "(1)")
    wp_page.expect_attributes "customField#{custom_field.id}": '42'
  end
end

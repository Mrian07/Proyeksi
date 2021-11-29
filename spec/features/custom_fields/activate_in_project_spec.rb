

require 'spec_helper'
require 'support/pages/custom_fields'

describe 'custom fields', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:cf_page) { Pages::CustomFields.new }
  let(:for_all_cf) { FactoryBot.create :list_wp_custom_field, is_for_all: true }
  let(:project_specific_cf) { FactoryBot.create :int_wp_custom_field }
  let(:work_package) do
    wp = FactoryBot.build(:work_package).tap do |wp|
      wp.type.custom_fields = [for_all_cf, project_specific_cf]
    end
    wp.save!
    wp
  end
  let(:wp_page) { Pages::FullWorkPackage.new(work_package) }
  let(:project_settings_page) { Pages::Projects::Settings.new(work_package.project) }

  before do
    login_as(user)
  end

  it 'is only visible in the project if it has been activated' do
    wp_page.visit!

    wp_page.expect_attributes "customField#{for_all_cf.id}": '-'
    wp_page.expect_no_attribute "customField#{project_specific_cf.id}"

    project_settings_page.visit_tab!('custom_fields')

    project_settings_page.activate_wp_custom_field(project_specific_cf)

    project_settings_page.save!

    wp_page.visit!

    wp_page.expect_attributes "customField#{for_all_cf.id}": '-'
    wp_page.expect_attributes "customField#{project_specific_cf.id}": '-'
  end
end

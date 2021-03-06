

require 'spec_helper'
require File.join(File.dirname(__FILE__), '..', 'support', 'custom_field_filter')
require File.join(File.dirname(__FILE__), '..', 'support', 'configuration_helper')

describe 'Custom field filter and group by caching', type: :request do
  include ProyeksiApp::Reporting::SpecHelper::CustomFieldFilterHelper
  include ProyeksiApp::Reporting::SpecHelper::ConfigurationHelper

  let(:project) { FactoryBot.create(:valid_project) }
  let(:user) { FactoryBot.create(:admin) }
  let(:custom_field) { FactoryBot.build(:work_package_custom_field) }
  let(:custom_field2) { FactoryBot.build(:work_package_custom_field) }

  before do
    allow(User).to receive(:current).and_return(user)

    custom_field.save!
  end

  after do
    CostQuery::Cache.reset!
  end

  def expect_group_by_all_to_include(custom_field)
    expect(CostQuery::GroupBy.all).to include(group_by_class_name_string(custom_field).constantize)
  end

  def expect_filter_all_to_include(custom_field)
    expect(CostQuery::Filter.all).to include(filter_class_name_string(custom_field).constantize)
  end

  def expect_group_by_all_to_not_exist(custom_field)
    # can not check for whether the element is included in CostQuery::GroupBy.all if it does not exist
    expect { group_by_class_name_string(custom_field).constantize }.to raise_error NameError
  end

  def expect_filter_all_to_not_exist(custom_field)
    # can not check for whether the element is included in CostQuery::Filter.all if it does not exist
    expect { filter_class_name_string(custom_field).constantize }.to raise_error NameError
  end

  def visit_cost_reports_index
    header "Content-Type", "text/html"
    header 'X-Requested-With', 'XMLHttpRequest'
    get "/projects/#{project.id}/cost_reports"
  end

  it 'removes the filter/group_by if the custom field is removed' do
    custom_field2.save!

    visit_cost_reports_index

    expect_group_by_all_to_include(custom_field)
    expect_group_by_all_to_include(custom_field2)

    expect_filter_all_to_include(custom_field)
    expect_filter_all_to_include(custom_field2)

    custom_field2.destroy

    visit_cost_reports_index

    expect_group_by_all_to_include(custom_field)
    expect_group_by_all_to_not_exist(custom_field2)

    expect_filter_all_to_include(custom_field)
    expect_filter_all_to_not_exist(custom_field2)
  end

  it 'removes the filter/group_by if the last custom field is removed' do
    visit_cost_reports_index

    expect_group_by_all_to_include(custom_field)
    expect_filter_all_to_include(custom_field)

    custom_field.destroy

    visit_cost_reports_index

    expect_group_by_all_to_not_exist(custom_field)
    expect_filter_all_to_not_exist(custom_field)
  end

  it 'allows for changing the db entries directly via SQL between requests \
      if no caching is done (this could also mean switching dbs)' do
    new_label = "our new label"
    mock_cache_classes_setting_with(false)

    visit_cost_reports_index

    expect_group_by_all_to_include(custom_field)
    expect_filter_all_to_include(custom_field)

    CustomField.where(id: custom_field.id)
               .update_all(name: new_label)

    visit_cost_reports_index

    expect_group_by_all_to_include(custom_field)
    expect_filter_all_to_include(custom_field)

    expect(group_by_class_name_string(custom_field).constantize.label).to eql(new_label)
    expect(filter_class_name_string(custom_field).constantize.label).to eql(new_label)
  end
end

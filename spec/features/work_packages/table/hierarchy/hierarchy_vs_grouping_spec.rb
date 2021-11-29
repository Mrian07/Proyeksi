

require 'spec_helper'

describe 'Work Package table hierarchy vs grouping', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project) }

  let(:wp_table) { Pages::WorkPackagesTable.new(project) }
  let(:hierarchy) { ::Components::WorkPackages::Hierarchies.new }
  let(:group_by) { ::Components::WorkPackages::GroupBy.new }

  before do
    login_as(user)
  end

  it 'is mutually exclusive' do
    wp_table.visit!

    hierarchy.expect_mode_enabled

    group_by.enable_via_header('Type')

    hierarchy.expect_mode_disabled

    hierarchy.enable_via_menu

    group_by.expect_not_grouped_by('Type')

    group_by.enable_via_menu('Type')

    hierarchy.expect_mode_disabled

    hierarchy.enable_via_header

    group_by.expect_not_grouped_by('Type')
  end
end

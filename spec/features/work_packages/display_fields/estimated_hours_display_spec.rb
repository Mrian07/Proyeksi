

require 'spec_helper'

RSpec.feature 'Estimated hours display' do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create :project }

  let(:hierarchy) { [] }

  let!(:work_packages) do
    build_work_package_hierarchy(
      hierarchy,
      :subject,
      :estimated_hours,
      shared_attributes: {
        project: project
      }
    )
  end

  let(:parent) { work_packages.first }
  let(:child) { work_packages.last }

  let!(:query) do
    query = FactoryBot.build :query, user: user, project: project
    query.column_names = %w[id subject estimated_hours]

    query.save!
    query
  end

  let(:wp_table) { Pages::WorkPackagesTable.new project }

  before do
    WorkPackages::UpdateAncestorsService
      .new(user: user, work_package: child)
      .call([:estimated_hours])

    login_as(user)
  end

  context "with both estimated and derived estimated time" do
    let(:hierarchy) do
      [
        {
          ["Parent", 1] => [
            ["Child", 3]
          ]
        }
      ]
    end

    scenario 'work package index', js: true do
      wp_table.visit_query query
      wp_table.expect_work_package_listed child

      wp_table.expect_work_package_with_attributes(
        parent, estimatedTime: "1 h(+3 h)"
      )
    end

    scenario 'work package details', js: true do
      visit work_package_path(parent.id)

      expect(page).to have_content("Estimated time\n1 h(+3 h)")
    end
  end

  context "with just estimated time" do
    let(:hierarchy) do
      [
        {
          ["Parent", 1] => [
            ["Child", 0]
          ]
        }
      ]
    end

    scenario 'work package index', js: true do
      wp_table.visit_query query
      wp_table.expect_work_package_listed child

      wp_table.expect_work_package_with_attributes(
        parent, subject: parent.subject, estimatedTime: "1 h"
      )
    end

    scenario 'work package details', js: true do
      visit work_package_path(parent.id)

      expect(page).to have_content("Estimated time\n1 h")
    end
  end

  context "with just derived estimated time" do
    let(:hierarchy) do
      [
        {
          ["Parent", 0] => [
            ["Child", 3]
          ]
        }
      ]
    end

    scenario 'work package index', js: true do
      wp_table.visit_query query
      wp_table.expect_work_package_listed child

      wp_table.expect_work_package_with_attributes(
        parent, subject: parent.subject, estimatedTime: "(3 h)"
      )
    end

    scenario 'work package details', js: true do
      visit work_package_path(parent.id)

      expect(page).to have_content("Estimated time\n(3 h)")
    end
  end

  context "with neither estimated nor derived estimated time" do
    let(:hierarchy) do
      [
        {
          ["Parent", 0] => [
            ["Child", 0]
          ]
        }
      ]
    end

    scenario 'work package index', js: true do
      wp_table.visit_query query
      wp_table.expect_work_package_listed child

      wp_table.expect_work_package_with_attributes(
        parent, subject: parent.subject, estimatedTime: "-"
      )
    end

    scenario 'work package details', js: true do
      visit work_package_path(parent.id)

      expect(page).to have_content("Estimated time\n-")
    end
  end
end

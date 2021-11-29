

require 'spec_helper'

RSpec.feature 'Work package show page', selenium: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project) }
  let(:work_package) do
    FactoryBot.build(:work_package,
                     project: project,
                     assigned_to: user,
                     responsible: user)
  end

  before do
    login_as(user)
    work_package.save!
  end

  scenario 'all different angular based work package views', js: true do
    wp_page = Pages::FullWorkPackage.new(work_package)

    wp_page.visit!

    wp_page.expect_attributes type: work_package.type.name.upcase,
                              status: work_package.status.name,
                              priority: work_package.priority.name,
                              assignee: work_package.assigned_to.name,
                              responsible: work_package.responsible.name
  end
end

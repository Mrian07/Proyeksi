
require 'spec_helper'

class WorkPackageCards
  include Capybara::DSL
  include RSpec::Matchers
  attr_reader :project

  def initialize(project = nil)
    @project = project
  end

  def open_full_screen_by_doubleclick(work_package)
    loading_indicator_saveguard
    page.driver.browser.action.double_click(card(work_package).native).perform

    Pages::FullWorkPackage.new(work_package, project)
  end

  def select_work_package(work_package)
    card(work_package).click
  end

  def card(work_package)
    page.find(".op-wp-single-card-#{work_package.id}")
  end
end

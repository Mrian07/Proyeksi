

require 'spec_helper'

RSpec.feature 'Keep current details tab', js: true, selenium: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project) }
  let!(:wp1) { FactoryBot.create(:work_package, project: project) }
  let!(:wp2) { FactoryBot.create(:work_package, project: project) }

  let(:wp_table) { Pages::WorkPackagesTable.new(project) }
  let(:split) { Pages::WorkPackagesTable.new(project) }

  before do
    login_as(user)
    wp_table.visit!
  end

  scenario 'Remembers the tab while navigating the page' do
    wp_table.expect_work_package_listed(wp1)
    wp_table.expect_work_package_listed(wp2)

    # Open details pane through button
    wp_split1 = wp_table.open_split_view(wp1)
    wp_split1.expect_subject
    wp_split1.visit_tab! :activity

    wp_split2 = wp_table.open_split_view(wp2)
    wp_split2.expect_subject
    wp_split2.expect_tab :activity

    # Open first WP by click on table
    wp_table.click_on_row(wp1)
    wp_split1.expect_subject
    wp_split1.expect_tab :activity

    # open work package full screen by button
    wp_full = wp_split1.switch_to_fullscreen
    wp_full.expect_tab :activity

    page.execute_script('window.history.back()')
    wp_split1.expect_tab :activity

    # Assert that overview tab is mapped to activity in show
    wp_split1.visit_tab! :overview
    wp_split1.expect_tab :overview

    wp_split1.switch_to_fullscreen
    wp_full.expect_tab :activity
    wp_full.ensure_page_loaded
  end
end

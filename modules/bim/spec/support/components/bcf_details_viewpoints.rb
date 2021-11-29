

module Components
  module BcfDetailsViewpoints
    def expect_viewpoint_count(number)
      expect(page).to have_selector('.ngx-gallery-thumbnail', visible: :all, count: number, wait: 20)
    end

    def expect_no_viewpoint_addable
      expect(page).to have_no_selector('a.button', text: 'Viewpoint')
    end

    def next_viewpoint
      page.find('.icon-arrow-right2.ngx-gallery-icon-content').click
    end

    def previous_viewpoint
      page.find('.icon-arrow-left2.ngx-gallery-icon-content').click
    end

    def show_current_viewpoint
      page.find('.icon-view-model.ngx-gallery-icon-content').click
    end

    def delete_current_viewpoint(confirm: true)
      page.find('.icon-delete.ngx-gallery-icon-content').click

      if confirm
        page.driver.browser.switch_to.alert.accept
      else
        page.driver.browser.switch_to.alert.dismiss
      end
    end

    def add_viewpoint
      page.find('a.button', text: 'Viewpoint').click
    end
  end
end

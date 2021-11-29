
require_relative './dropdown'

module Components
  class QuickAddMenu < Dropdown

    def expect_visible
      expect(trigger_element).to be_present
    end

    def expect_invisible
      expect { trigger_element }.to raise_error(Capybara::ElementNotFound)
    end

    def expect_add_project(present: true)
      expect_link 'New project', present: present
    end

    def expect_user_invite(present: true)
      expect_link 'Invite user', present: present
    end

    def expect_work_package_type(*names, present: true)
      within_dropdown do
        expect(page).to have_text 'WORK PACKAGES'
      end

      names.each do |name|
        expect_link name, present: present
      end
    end

    def expect_no_work_package_types
      within_dropdown do
        expect(page).to have_no_text 'Work packages'
      end
    end

    def click_link(matcher)
      within_dropdown do
        page.click_link matcher
      end
    end

    def expect_link(matcher, present: true)
      within_dropdown do
        if present
          expect(page).to have_link matcher
        else
          expect(page).to have_no_link matcher
        end
      end
    end

    def trigger_element
      page.find('a[title="Open quick add menu"]')
    end
  end
end

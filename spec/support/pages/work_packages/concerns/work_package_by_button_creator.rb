

module Pages
  module WorkPackages
    module Concerns
      module WorkPackageByButtonCreator
        def create_wp_by_button(type)
          click_wp_create_button

          find('#types-context-menu .menu-item', text: type.name.upcase, wait: 10).click

          create_page_class_instance(type)
        end

        def click_wp_create_button
          find('.add-work-package:not([disabled])', text: 'Create').click
        end

        def expect_wp_create_button
          expect(page)
            .to have_selector('.add-work-package:not([disabled])', text: 'Create')
        end

        def expect_wp_create_button_disabled
          expect(page)
            .to have_selector('.add-work-package[disabled]', text: 'Create')
        end

        def expect_type_available_for_create(type)
          click_wp_create_button

          expect(page)
            .to have_selector('#types-context-menu .menu-item', text: type.name.upcase)
        end

        def expect_type_not_available_for_create(type)
          click_wp_create_button

          expect(page)
            .to have_no_selector('#types-context-menu .menu-item', text: type.name.upcase)
        end

        private

        def create_page_class_instance(_type)
          create_page_class.new(project: project)
        end

        def create_page_class
          raise NotImplementedError
        end
      end
    end
  end
end

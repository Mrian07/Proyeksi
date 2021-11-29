

require 'support/pages/page'

module Pages
  module Admin
    module IndividualPrincipals
      class Edit < ::Pages::Page
        attr_reader :id
        attr_reader :individual_principal

        def initialize(individual_principal)
          @individual_principal = individual_principal
          @id = individual_principal.id
        end

        def path
          "/#{individual_principal.class.name.underscore}s/#{id}/edit"
        end

        def open_projects_tab!
          within('.content--tabs') do
            click_on 'Projects'
          end
        end

        def add_to_project!(project_name, as:)
          open_projects_tab!
          select_project! project_name
          Array(as).each { |role| check role }
          click_on 'Add'

          expect_project(project_name)
        end

        def remove_from_project!(name)
          open_projects_tab!
          find_project(name).find('a[data-method=delete]').click
        end

        def edit_roles!(membership, roles)
          find("#member-#{membership.id} .memberships--edit-button").click

          page.within("#member-#{membership.id}-roles-form") do
            page.all('.form--check-box').each do |f|
              begin
                f.set false
              rescue Selenium::WebDriver::Error::InvalidElementStateError
                # Happens if an element is disabled
              end
            end
            Array(roles).each { |role| page.check role }
            page.find('.memberships--edit-submit-button').click
          end
        end

        def expect_project(project_name)
          expect(page).to have_selector('tr', text: project_name, wait: 10)
        end

        def expect_no_membership(project_name)
          expect(page).to have_no_selector('tr', text: project_name)
        end

        def expect_roles(project_name, roles)
          row = page.find('tr', text: project_name, wait: 10)

          roles.each do |role|
            expect(row).to have_selector('span', text: role)
          end
        end

        def find_project(name)
          find('tr', text: name)
        end

        def has_project?(name)
          has_selector? 'tr', text: name
        end

        def select_project!(project_name)
          select(project_name, from: 'membership_project_id')
        end

        def activate!
          within '.toolbar-items' do
            click_button 'Activate'
          end
        end
      end
    end
  end
end



require 'support/pages/page'

module Pages
  class Grid < ::Pages::Page
    def add_widget(row_number, column_number, location, name)
      within_add_widget_modal(row_number, column_number, location) do
        expect(page)
          .to have_content(I18n.t('js.grid.add_widget'))

        SeleniumHubWaiter.wait
        page.find('.grid--addable-widget', text: Regexp.new("^#{name}$")).click
      end
    end

    def expect_no_help_mode
      expect(page)
        .to have_no_selector('.toolbar-item .icon-add')
    end

    def expect_unable_to_add_widget(row_number, column_number, location, name = nil)
      if name
        expect_specific_widget_unaddable(row_number, column_number, location, name)
      else
        expect_widget_adding_prohibited_generally(row_number, column_number)
      end
    end

    def expect_add_widget_enterprise_edition_notice(row_number, column_number, location)
      within_add_widget_modal(row_number, column_number, location) do
        expect(page)
          .to have_content(I18n.t('js.grid.add_widget'))

        expect(page)
          .to have_selector('.op-toast.-ee-upsale', text: I18n.t('js.upsale.ee_only'))
      end
    end

    def area_of(row_number, column_number, location = :within)
      real_row, real_column = case location
                              when :within
                                [row_number * 2, column_number * 2]
                              when :row
                                [row_number * 2 - 1, column_number * 2]
                              when :column
                                [row_number * 2, column_number * 2 - 1]
                              end

      ::Components::Grids::GridArea.of(real_row, real_column).area
    end

    private

    def within_add_widget_modal(row_number, column_number, location, &block)
      area = area_of(row_number, column_number, location)
      area.hover
      area.find('.grid--widget-add', visible: :all).click

      within '.op-modal', &block
    end

    def expect_widget_adding_prohibited_generally(row_number = 1, column_number = 1)
      area = area_of(row_number, column_number)
      area.hover

      expect(area)
        .to have_no_selector('.grid--widget-add')
    end

    def expect_specific_widget_unaddable(row_number, column_number, location, name)
      within_add_widget_modal(row_number, column_number, location) do
        expect(page)
          .to have_content(I18n.t('js.grid.add_widget'))

        expect(page)
          .not_to have_selector('.grid--addable-widget', text: Regexp.new("^#{name}$"))
      end
    end
  end
end

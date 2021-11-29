

require 'support/pages/page'
require_relative './board_page'

module Pages
  class BoardIndex < Page
    attr_reader :project

    def initialize(project = nil)
      @project = project
    end

    def visit!
      if project
        visit project_work_package_boards_path(project)
      else
        visit work_package_boards_path
      end
    end

    def expect_editable(editable)
      # Editable / draggable check
      expect(page).to have_conditional_selector(editable, '.buttons a.icon-delete')
      # Create button
      expect(page).to have_conditional_selector(editable, '.toolbar-item a', text: 'Board')
    end

    def expect_board(name, present: true)
      expect(page).to have_conditional_selector(present, 'td.name', text: name)
    end

    def create_board(action: nil, expect_empty: false)
      page.find('.toolbar-item a', text: 'Board').click

      if action == nil
        find('.tile-block-title', text: 'Basic').click
      else
        find('.tile-block-title', text: action.to_s[0..5]).click
      end

      if expect_empty
        expect(page).to have_selector('.boards-list--add-item-text', wait: 10)
        expect(page).to have_no_selector('.boards-list--item')
      else
        expect(page).to have_selector('.boards-list--item', wait: 10)
      end

      ::Pages::Board.new ::Boards::Grid.last
    end

    def open_board(board)
      page.find('td.name a', text: board.name).click
      ::Pages::Board.new board
    end
  end
end

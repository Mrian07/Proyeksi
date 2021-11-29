

require 'support/pages/page'

module Pages
  class DestroyInfo < Page
    attr_accessor :budget

    def initialize(budget)
      self.budget = budget
    end

    def expect_loaded
      expect(page)
        .to have_content("#{I18n.t(:button_delete)} #{I18n.t(:label_budget_id, id: budget.id)}: #{budget.subject}")
    end

    def expect_reassign_option
      expect(page)
        .to have_field('todo_reassign')
    end

    def expect_no_reassign_option
      expect(page)
        .not_to have_field('todo_reassign')
    end

    def select_reassign_option(budget_name)
      select(budget_name, from: 'reassign_to_id')
    end

    def expect_delete_option
      expect(page)
        .to have_field('todo_delete')
    end

    def select_delete_option
      choose('todo_delete')
    end

    def delete
      click_button 'Apply'
    end

    def path
      destroy_info_budget_path(budget)
    end
  end
end

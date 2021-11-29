

require 'spec_helper'

describe BudgetsController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/blubs/budgets/new')).to route_to(controller: 'budgets',
                                                             action: 'new',
                                                             project_id: 'blubs')
    }
    it {
      expect(post('/projects/blubs/budgets')).to route_to(controller: 'budgets',
                                                          action: 'create',
                                                          project_id: 'blubs')
    }
    it {
      expect(get('/projects/blubs/budgets')).to route_to(controller: 'budgets',
                                                         action: 'index',
                                                         project_id: 'blubs')
    }
    it {
      expect(get('/budgets/5')).to route_to(controller: 'budgets',
                                            action: 'show',
                                            id: '5')
    }
    it {
      expect(put('/budgets/5')).to route_to(controller: 'budgets',
                                            action: 'update',
                                            id: '5')
    }
    it {
      expect(delete('/budgets/5')).to route_to(controller: 'budgets',
                                               action: 'destroy',
                                               id: '5')
    }
    it {
      expect(post('/projects/42/budgets/update_material_budget_item')).to route_to(controller: 'budgets',
                                                                                   action: 'update_material_budget_item',
                                                                                   project_id: '42')
    }
    it {
      expect(post('/projects/42/budgets/update_labor_budget_item')).to route_to(controller: 'budgets',
                                                                                action: 'update_labor_budget_item',
                                                                                project_id: '42')
    }
    it {
      expect(get('/budgets/5/copy')).to route_to(controller: 'budgets',
                                                 action: 'copy',
                                                 id: '5')
    }
  end
end

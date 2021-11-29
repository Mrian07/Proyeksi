

import { Injector, NgModule } from '@angular/core';
import { OpenProjectPluginContext } from 'core-app/features/plugins/plugin-context';
import { multiInput } from 'reactivestates';
import { PlannedCostsFormAugment } from 'core-app/features/plugins/linked/budgets/augment/planned-costs-form';
import { CostBudgetSubformAugmentService } from 'core-app/features/plugins/linked/budgets/augment/cost-budget-subform.augment.service';
import { CostSubformAugmentService } from './augment/cost-subform.augment.service';
import { BudgetResource } from './hal/resources/budget-resource';

export function initializeCostsPlugin(injector:Injector) {
  window.OpenProject.getPluginContext().then((pluginContext:OpenProjectPluginContext) => {
    pluginContext.services.editField.extendFieldType('select', ['Budget']);

    const displayFieldService = pluginContext.services.displayField;
    displayFieldService.extendFieldType('resource', ['Budget']);

    const halResourceService = pluginContext.services.halResource;
    halResourceService.registerResource('Budget', { cls: BudgetResource });

    const { states } = pluginContext.services;
    states.add('budgets', multiInput<BudgetResource>());

    // Augment previous cost-subforms
    new CostSubformAugmentService();
    PlannedCostsFormAugment.listen();

    const budgetSubform = injector.get(CostBudgetSubformAugmentService);
    budgetSubform.listen();
  });
}

@NgModule({
  providers: [
    CostBudgetSubformAugmentService,
  ],
})
export class PluginModule {
  constructor(injector:Injector) {
    initializeCostsPlugin(injector);
  }
}

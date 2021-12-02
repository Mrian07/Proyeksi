

import { Injector, NgModule } from '@angular/core';
import { ProyeksiAppPluginContext } from 'core-app/features/plugins/plugin-context';
import { CostsByTypeDisplayField } from './wp-display/costs-by-type-display-field.module';
import { CurrencyDisplayField } from './wp-display/currency-display-field.module';

export function initializeCostsPlugin(injector:Injector) {
  window.ProyeksiApp.getPluginContext().then((pluginContext:ProyeksiAppPluginContext) => {
    const displayFieldService = pluginContext.services.displayField;
    displayFieldService.addFieldType(CostsByTypeDisplayField, 'costs', ['costsByType']);
    displayFieldService.addFieldType(CurrencyDisplayField, 'currency', ['laborCosts', 'materialCosts', 'overallCosts']);

    pluginContext.hooks.workPackageSingleContextMenu((params:any) => ({
      key: 'log_costs',
      icon: 'icon-projects',
      indexBy(actions:any) {
        const index = _.findIndex(actions, { key: 'log_time' });
        return index !== -1 ? index + 1 : actions.length;
      },
      resource: 'workPackage',
      link: 'logCosts',
    }));

    pluginContext.hooks.workPackageTableContextMenu((params:any) => ({
      key: 'log_costs',
      icon: 'icon-projects',
      link: 'logCosts',
      indexBy(actions:any) {
        const index = _.findIndex(actions, { link: 'logTime' });
        return index !== -1 ? index + 1 : actions.length;
      },
      text: I18n.t('js.button_log_costs'),
    }));
  });
}

@NgModule({
  providers: [
  ],
})
export class PluginModule {
  constructor(injector:Injector) {
    initializeCostsPlugin(injector);
  }
}

import { Injector, NgModule } from '@angular/core';
import { HookService } from 'core-app/features/plugins/hook-service';
import { ProyeksiAppPluginContext } from 'core-app/features/plugins/plugin-context';
import { debugLog } from 'core-app/shared/helpers/debug_output';

@NgModule({
  providers: [
    HookService,
  ],
})
export class ProyeksiappPluginsModule {
  constructor(injector:Injector) {
    debugLog('Registering OpenProject plugin context');
    const pluginContext = new ProyeksiAppPluginContext(injector);
    window.ProyeksiApp.pluginContext.putValue(pluginContext);
  }
}

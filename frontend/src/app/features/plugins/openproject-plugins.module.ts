import { Injector, NgModule } from '@angular/core';
import { HookService } from 'core-app/features/plugins/hook-service';
import { OpenProjectPluginContext } from 'core-app/features/plugins/plugin-context';
import { debugLog } from 'core-app/shared/helpers/debug_output';

@NgModule({
  providers: [
    HookService,
  ],
})
export class OpenprojectPluginsModule {
  constructor(injector:Injector) {
    debugLog('Registering OpenProject plugin context');
    const pluginContext = new OpenProjectPluginContext(injector);
    window.OpenProject.pluginContext.putValue(pluginContext);
  }
}

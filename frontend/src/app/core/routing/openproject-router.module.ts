

import { Injector, NgModule } from '@angular/core';
import { FirstRouteService } from 'core-app/core/routing/first-route-service';
import { UIRouterModule } from '@uirouter/angular';
import { ApplicationBaseComponent } from 'core-app/core/routing/base/application-base.component';
import {
  initializeUiRouterListeners,
  OPENPROJECT_ROUTES,
  uiRouterConfiguration,
} from 'core-app/core/routing/openproject.routes';

@NgModule({
  imports: [
    UIRouterModule.forRoot({
      states: OPENPROJECT_ROUTES,
      useHash: false,
      config: uiRouterConfiguration,
    } as any),
  ],
  providers: [
    FirstRouteService,
  ],
  declarations: [
    ApplicationBaseComponent,
  ],
})
export class OpenprojectRouterModule {
  constructor(injector:Injector) {
    initializeUiRouterListeners(injector);
  }
}

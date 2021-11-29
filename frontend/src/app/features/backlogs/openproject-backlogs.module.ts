

import { NgModule } from '@angular/core';
import { UIRouterModule } from '@uirouter/angular';
import { BacklogsPageComponent } from 'core-app/features/backlogs/backlogs-page/backlogs-page.component';
import { BACKLOGS_ROUTES } from 'core-app/features/backlogs/openproject-backlogs.routes';

@NgModule({
  imports: [
    // Routes for /backlogs
    UIRouterModule.forChild({
      states: BACKLOGS_ROUTES,
    }),
  ],
  declarations: [
    BacklogsPageComponent,
  ],
})
export class OpenprojectBacklogsModule {
}

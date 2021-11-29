

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { Ng2StateDeclaration, UIRouter, UIRouterModule } from '@uirouter/angular';
import { OpenprojectGridsModule } from 'core-app/shared/components/grids/openproject-grids.module';
import { OverviewComponent } from 'core-app/features/overview/overview.component';

const menuItemClass = 'overview-menu-item';

export const OVERVIEW_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'overview',
    parent: 'optional_project',
    // The trailing slash is important
    // cf., https://community.openproject.com/wp/29754
    url: '/',
    data: {
      menuItem: menuItemClass,
    },
    component: OverviewComponent,
  },
];

export function uiRouterOverviewConfiguration(uiRouter:UIRouter) {
  // Ensure projects/:project_id/ are being redirected correctly
  // cf., https://community.openproject.com/wp/29754
  uiRouter.urlService.rules
    .when(
      new RegExp('^/projects(?!/new$)/([^/]+)$'),
      (match) => `/projects/${match[1]}/`,
    );
}

@NgModule({
  imports: [
    OPSharedModule,

    OpenprojectGridsModule,

    UIRouterModule.forChild({
      states: OVERVIEW_ROUTES,
      config: uiRouterOverviewConfiguration,
    }),
  ],
  providers: [
  ],
  declarations: [
    OverviewComponent,
  ],
})
export class OpenprojectOverviewModule {
}

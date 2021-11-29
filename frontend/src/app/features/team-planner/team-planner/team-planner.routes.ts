

import { Ng2StateDeclaration } from '@uirouter/angular';
import { makeSplitViewRoutes } from 'core-app/features/work-packages/routing/split-view-routes.template';
import { WorkPackageSplitViewComponent } from 'core-app/features/work-packages/routing/wp-split-view/wp-split-view.component';
import { WorkPackagesBaseComponent } from 'core-app/features/work-packages/routing/wp-base/wp--base.component';
import { TeamPlannerPageComponent } from 'core-app/features/team-planner/team-planner/page/team-planner-page.component';
import { TeamPlannerComponent } from 'core-app/features/team-planner/team-planner/planner/team-planner.component';

export const TEAM_PLANNER_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'team_planner',
    parent: 'optional_project',
    url: '/team_planner',
    redirectTo: 'team_planner.page',
    views: {
      '!$default': { component: WorkPackagesBaseComponent },
    },
  },
  {
    name: 'team_planner.page',
    component: TeamPlannerPageComponent,
    redirectTo: 'team_planner.page.show',
  },
  {
    name: 'team_planner.page.show',
    data: {
      baseRoute: 'team_planner.page.show',
    },
    views: {
      'content-left': { component: TeamPlannerComponent },
    },
  },
  ...makeSplitViewRoutes(
    'team_planner.page.show',
    undefined,
    WorkPackageSplitViewComponent,
  ),
];

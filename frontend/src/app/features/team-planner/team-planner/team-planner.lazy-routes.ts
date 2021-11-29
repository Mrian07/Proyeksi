

import { Ng2StateDeclaration } from '@uirouter/angular';

export const TEAM_PLANNER_LAZY_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'team_planner.**',
    parent: 'optional_project',
    url: '/team_planner',
    loadChildren: () => import('./team-planner.module').then((m) => m.TeamPlannerModule),
  },
];

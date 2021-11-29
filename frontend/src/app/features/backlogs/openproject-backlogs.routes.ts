

import { Ng2StateDeclaration } from '@uirouter/angular';
import { BacklogsPageComponent } from 'core-app/features/backlogs/backlogs-page/backlogs-page.component';

export const BACKLOGS_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'backlogs',
    parent: 'optional_project',
    url: '/backlogs',
    component: BacklogsPageComponent,
  },
  {
    name: 'backlogs_sprint',
    parent: 'optional_project',
    url: '/sprints/{sprintId:int}/taskboard',
    component: BacklogsPageComponent,
  },
  {
    name: 'backlogs_burndown',
    parent: 'optional_project',
    url: '/sprints/{sprintId:int}/burndown_chart',
    component: BacklogsPageComponent,
  },
];

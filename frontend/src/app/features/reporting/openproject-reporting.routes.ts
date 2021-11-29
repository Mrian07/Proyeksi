

import { Ng2StateDeclaration } from '@uirouter/angular';
import { ReportingPageComponent } from 'core-app/features/reporting/reporting-page/reporting-page.component';

export const REPORTING_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'reporting',
    parent: 'optional_project',
    url: '/cost_reports',
    component: ReportingPageComponent,
  },
  {
    name: 'reporting.show',
    url: '/:id',
    component: ReportingPageComponent,
  },
];

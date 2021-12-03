

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { Ng2StateDeclaration, UIRouterModule } from '@uirouter/angular';
import { DisplayJobPageComponent } from 'core-app/features/job-status/display-job-page/display-job-page.component';
import { JobStatusModalComponent } from 'core-app/features/job-status/job-status-modal/job-status.modal';

export const JOB_STATUS_ROUTE:Ng2StateDeclaration[] = [
  {
    name: 'job-statuses',
    url: '/job_statuses/{jobId:[a-z0-9-]+}',
    parent: 'optional_project',
    component: DisplayJobPageComponent,
    data: {
      bodyClasses: 'router--job-statuses',
    },
  },
];

@NgModule({
  imports: [
    // Commons
    OPSharedModule,
    OpenprojectModalModule,

    // Routes for /job_statuses/:uuid
    UIRouterModule.forChild({ states: JOB_STATUS_ROUTE }),

  ],
  declarations: [
    DisplayJobPageComponent,
    JobStatusModalComponent,
  ],
})
export class ProyeksiAppJobStatusModule {
}

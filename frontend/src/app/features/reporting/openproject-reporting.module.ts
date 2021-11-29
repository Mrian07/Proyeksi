

import { NgModule } from '@angular/core';
import { UIRouterModule } from '@uirouter/angular';
import {
  REPORTING_ROUTES,
} from 'core-app/features/reporting/openproject-reporting.routes';
import { ReportingPageComponent } from 'core-app/features/reporting/reporting-page/reporting-page.component';

@NgModule({
  imports: [
    // Routes for /cost_reports
    UIRouterModule.forChild({
      states: REPORTING_ROUTES,
    }),
  ],
  declarations: [
    ReportingPageComponent,
  ],
})
export class OpenprojectReportingModule {
}

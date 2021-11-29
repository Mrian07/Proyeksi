

import { OPSharedModule } from 'core-app/shared/shared.module';
import { NgModule } from '@angular/core';
import { FullCalendarModule } from '@fullcalendar/angular';
import { WorkPackagesCalendarEntryComponent } from 'core-app/shared/components/calendar/wp-calendar-entry/wp-calendar-entry.component';
import { WorkPackagesCalendarController } from 'core-app/shared/components/calendar/wp-calendar/wp-calendar.component';
import { OpenprojectWorkPackagesModule } from 'core-app/features/work-packages/openproject-work-packages.module';
import { Ng2StateDeclaration, UIRouterModule } from '@uirouter/angular';
import { TimeEntryCalendarComponent } from 'core-app/shared/components/calendar/te-calendar/te-calendar.component';
import { OpenprojectFieldsModule } from 'core-app/shared/components/fields/openproject-fields.module';
import { OpenprojectTimeEntriesModule } from 'core-app/shared/components/time_entries/openproject-time-entries.module';

const menuItemClass = 'calendar-menu-item';

export const CALENDAR_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'work-packages.calendar',
    url: '/calendar',
    component: WorkPackagesCalendarEntryComponent,
    reloadOnSearch: false,
    data: {
      bodyClasses: 'router--work-packages-calendar',
      menuItem: menuItemClass,
      parent: 'work-packages',
    },
  },
];

@NgModule({
  imports: [
    // Commons
    OPSharedModule,

    // Routes for /work_packages/calendar
    UIRouterModule.forChild({ states: CALENDAR_ROUTES }),

    // Work Package module
    OpenprojectWorkPackagesModule,

    // Time entry module
    OpenprojectTimeEntriesModule,

    // Editable fields e.g. for modals
    OpenprojectFieldsModule,

    // Calendar component
    FullCalendarModule,
  ],
  declarations: [
    // Work package calendars
    WorkPackagesCalendarEntryComponent,
    WorkPackagesCalendarController,
    TimeEntryCalendarComponent,
  ],
  exports: [
    WorkPackagesCalendarController,
    TimeEntryCalendarComponent,
  ],
})
export class OpenprojectCalendarModule {
}

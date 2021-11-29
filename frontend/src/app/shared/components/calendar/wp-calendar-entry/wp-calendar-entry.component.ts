

import { Component, ViewChild } from '@angular/core';
import { WorkPackagesViewBase } from 'core-app/features/work-packages/routing/wp-view-base/work-packages-view.base';
import { WorkPackagesCalendarController } from 'core-app/shared/components/calendar/wp-calendar/wp-calendar.component';

@Component({
  templateUrl: './wp-calendar-entry.component.html',
})

export class WorkPackagesCalendarEntryComponent extends WorkPackagesViewBase {
  @ViewChild(WorkPackagesCalendarController, { static: true }) calendarElement:WorkPackagesCalendarController;

  protected set loadingIndicator(promise:Promise<unknown>) {
    this.loadingIndicatorService.indicator('calendar-entry').promise = promise;
  }

  public refresh(visibly:boolean, firstPage:boolean):Promise<unknown> {
    return this.loadingIndicator = this.wpListService.loadCurrentQueryFromParams(this.projectIdentifier);
  }
}

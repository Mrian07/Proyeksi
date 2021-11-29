

import { Component, Input } from '@angular/core';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

@Component({
  selector: 'op-date-time',
  template: `
    <span title="{{date}} {{ time }}">
      <span [textContent]="date"></span>
      <span>&nbsp;</span>
      <span [textContent]="time"></span>
    </span>
  `,
})
export class OpDateTimeComponent {
  @Input('dateTimeValue') dateTimeValue:any;

  public date:any;

  public time:any;

  constructor(readonly timezoneService:TimezoneService) {
  }

  ngOnInit() {
    const c = this.timezoneService.formattedDatetimeComponents(this.dateTimeValue);
    this.date = c[0];
    this.time = c[1];
  }
}

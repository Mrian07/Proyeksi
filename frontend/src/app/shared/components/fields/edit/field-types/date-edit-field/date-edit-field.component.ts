

import { Component, OnInit } from '@angular/core';
import * as moment from 'moment';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

@Component({
  template: `
    <op-single-date-picker
        tabindex="-1"
        (changed)="onValueSelected($event)"
        (canceled)="onCancel()"
        [initialDate]="formatter(value)"
        [required]="required"
        [disabled]="inFlight"
        [id]="handler.htmlId"
        classes="inline-edit--field">
    </op-single-date-picker>
  `,
})
export class DateEditFieldComponent extends EditFieldComponent implements OnInit {
  @InjectField() readonly timezoneService:TimezoneService;

  @InjectField() opModalService:OpModalService;

  ngOnInit() {
    super.ngOnInit();
  }

  public onValueSelected(data:string) {
    this.value = this.parser(data);
    this.handler.handleUserSubmit();
  }

  public onCancel() {
    this.handler.handleUserCancel();
  }

  public parser(data:any) {
    if (moment(data, 'YYYY-MM-DD', true).isValid()) {
      return data;
    }
    return null;
  }

  public formatter(data:any) {
    if (moment(data, 'YYYY-MM-DD', true).isValid()) {
      const d = this.timezoneService.parseDate(data);
      return this.timezoneService.formattedISODate(d);
    }
    return null;
  }
}

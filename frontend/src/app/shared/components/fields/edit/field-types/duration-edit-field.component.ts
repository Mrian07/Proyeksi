

import * as moment from 'moment';
import { Component } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

@Component({
  template: `
    <input type="number"
           step="0.01"
           class="inline-edit--field op-input"
           #input
           [attr.aria-required]="required"
           [ngModel]="formatter(value)"
           (ngModelChange)="value = parser($event, input)"
           [attr.required]="required"
           (keydown)="handler.handleUserKeydown($event)"
           [disabled]="inFlight"
           [id]="handler.htmlId" />
  `,
})
export class DurationEditFieldComponent extends EditFieldComponent {
  @InjectField() TimezoneService:TimezoneService;

  public parser(value:any, input:any) {
    // Managing decimal separators in a multi-language app is a complex topic:
    // https://www.ctrl.blog/entry/html5-input-number-localization.html
    // Depending on the locale of the OS, the browser or the app itself,
    // a decimal separator could be considered valid or invalid.
    // When a decimal operator is considered invalid (e.g: 1. in Chrome with
    // 'en' locale), the input emits null as a value and its state is marked
    // not valid, but the value remains in the input. Adding a value after the
    // 'invalid' separator (e.g: 1.2) emits a valid value.
    // In order to allow both decimal separator (period and comma) in any
    // context, we check the validity of the input and, if it's not valid, we
    // default to the previous value, emulating the way the browsers work with
    // valid separators (e.g: introducing 1. would set 1 as a value).
    if (value == null && !input.validity.valid) {
      value = this.value || 0;
    }

    return moment.duration(value, 'hours');
  }

  public formatter(value:any) {
    return Number(moment.duration(value).asHours().toFixed(2));
  }

  protected parseValue(val:moment.Moment | null) {
    if (val === null) {
      return val;
    }

    let parsedValue;
    if (val.isValid()) {
      parsedValue = val.toISOString();
    } else {
      parsedValue = null;
    }

    return parsedValue;
  }
}

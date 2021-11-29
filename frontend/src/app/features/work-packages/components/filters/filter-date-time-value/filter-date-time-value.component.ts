

import {
  Component, Input, OnInit, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { Moment } from 'moment';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { AbstractDateTimeValueController } from '../abstract-filter-date-time-value/abstract-filter-date-time-value.controller';

@Component({
  selector: 'filter-date-time-value',
  templateUrl: './filter-date-time-value.component.html',
})
export class FilterDateTimeValueComponent extends AbstractDateTimeValueController implements OnInit {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new DebouncedEventEmitter<QueryFilterInstanceResource>(componentDestroyed(this));

  constructor(readonly I18n:I18nService,
    readonly timezoneService:TimezoneService) {
    super(I18n, timezoneService);
  }

  public get value():HalResource|string {
    return this.filter.values[0];
  }

  public get valueString() {
    return this.filter.values[0].toString();
  }

  public set value(val) {
    this.filter.values = [val as string];
    this.filterChanged.emit(this.filter);
  }

  public get lowerBoundary():Moment|null {
    if (this.value && this.timezoneService.isValidISODateTime(this.valueString)) {
      return this.timezoneService.parseDatetime(this.valueString);
    }

    return null;
  }

  public get upperBoundary():Moment|null {
    if (this.value && this.timezoneService.isValidISODateTime(this.valueString)) {
      return this.timezoneService.parseDatetime(this.valueString).add(24, 'hours');
    }

    return null;
  }
}

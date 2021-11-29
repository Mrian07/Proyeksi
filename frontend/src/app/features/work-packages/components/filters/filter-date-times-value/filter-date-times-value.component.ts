

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Moment } from 'moment';
import {
  Component, Input, OnInit, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { AbstractDateTimeValueController } from '../abstract-filter-date-time-value/abstract-filter-date-time-value.controller';

@Component({
  selector: 'filter-date-times-value',
  templateUrl: './filter-date-times-value.component.html',
})
export class FilterDateTimesValueComponent extends AbstractDateTimeValueController implements OnInit {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new DebouncedEventEmitter<QueryFilterInstanceResource>(componentDestroyed(this));

  readonly text = {
    spacer: this.I18n.t('js.filter.value_spacer'),
  };

  constructor(readonly I18n:I18nService,
    readonly timezoneService:TimezoneService) {
    super(I18n, timezoneService);
  }

  public get begin():HalResource|string {
    return this.filter.values[0];
  }

  public set begin(val) {
    this.filter.values[0] = val || '';
    this.filterChanged.emit(this.filter);
  }

  public get end() {
    return this.filter.values[1];
  }

  public set end(val) {
    this.filter.values[1] = val || '';
    this.filterChanged.emit(this.filter);
  }

  public get lowerBoundary():Moment|null {
    if (this.begin && this.timezoneService.isValidISODateTime(this.begin.toString())) {
      return this.timezoneService.parseDatetime(this.begin.toString());
    }
    return null;
  }

  public get upperBoundary():Moment|null {
    if (this.end && this.timezoneService.isValidISODateTime(this.end.toString())) {
      return this.timezoneService.parseDatetime(this.end.toString());
    }
    return null;
  }
}

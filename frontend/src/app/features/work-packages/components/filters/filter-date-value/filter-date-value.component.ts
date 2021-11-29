

import { Component, Input, Output } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';

@Component({
  selector: 'filter-date-value',
  templateUrl: './filter-date-value.component.html',
})
export class FilterDateValueComponent extends UntilDestroyedMixin {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new DebouncedEventEmitter<QueryFilterInstanceResource>(componentDestroyed(this));

  constructor(readonly timezoneService:TimezoneService,
    readonly I18n:I18nService) {
    super();
  }

  public get value():HalResource|string {
    return this.filter.values[0];
  }

  public set value(val) {
    this.filter.values = [val as string];
    this.filterChanged.emit(this.filter);
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

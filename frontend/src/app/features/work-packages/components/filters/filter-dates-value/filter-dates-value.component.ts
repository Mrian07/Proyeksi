

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Component, Input, Output } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import * as moment from 'moment';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';

@Component({
  selector: 'filter-dates-value',
  templateUrl: './filter-dates-value.component.html',
})
export class FilterDatesValueComponent extends UntilDestroyedMixin {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new DebouncedEventEmitter<QueryFilterInstanceResource>(componentDestroyed(this));

  readonly text = {
    spacer: this.I18n.t('js.filter.value_spacer'),
  };

  constructor(readonly timezoneService:TimezoneService,
    readonly I18n:I18nService) {
    super();
  }

  public get begin():any {
    return this.filter.values[0];
  }

  public set begin(val:any) {
    this.filter.values[0] = val || '';
    this.filterChanged.emit(this.filter);
  }

  public get end():HalResource|string {
    return this.filter.values[1];
  }

  public set end(val) {
    this.filter.values[1] = val || '';
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

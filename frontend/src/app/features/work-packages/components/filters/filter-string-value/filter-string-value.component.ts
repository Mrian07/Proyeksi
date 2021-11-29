

import { Component, Input, Output } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';

@Component({
  selector: 'filter-string-value',
  templateUrl: './filter-string-value.component.html',
})
export class FilterStringValueComponent extends UntilDestroyedMixin {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new DebouncedEventEmitter<QueryFilterInstanceResource>(componentDestroyed(this));

  readonly text = {
    enter_text: this.I18n.t('js.work_packages.description_enter_text'),
  };

  constructor(readonly I18n:I18nService) {
    super();
  }

  public get value():HalResource|string {
    return this.filter.values[0];
  }

  public set value(val) {
    if (val.length) {
      this.filter.values[0] = val;
    } else {
      this.filter.values.length = 0;
    }
    this.filterChanged.emit(this.filter);
  }
}

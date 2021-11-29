

import { Component, Input, Output } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { QueryFilterResource } from 'core-app/features/hal/resources/query-filter-resource';

@Component({
  selector: 'filter-integer-value',
  templateUrl: './filter-integer-value.component.html',
})
export class FilterIntegerValueComponent extends UntilDestroyedMixin {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new DebouncedEventEmitter<QueryFilterInstanceResource>(componentDestroyed(this));

  constructor(readonly I18n:I18nService,
    readonly schemaCache:SchemaCacheService) {
    super();
  }

  public get value() {
    return parseInt(this.filter.values[0] as string);
  }

  public set value(val) {
    if (typeof (val) === 'number') {
      this.filter.values = [val.toString()];
    } else {
      this.filter.values = [];
    }

    this.filterChanged.emit(this.filter);
  }

  public get unit() {
    switch ((this.schema.filter.allowedValues as QueryFilterResource[])[0].id) {
      case 'startDate':
      case 'dueDate':
      case 'updatedAt':
      case 'createdAt':
        return this.I18n.t('js.work_packages.time_relative.days');
      default:
        return '';
    }
  }

  private get schema() {
    return this.schemaCache.of(this.filter);
  }
}



import {
  Component, EventEmitter, Input, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';

@Component({
  selector: 'filter-boolean-value',
  templateUrl: './filter-boolean-value.component.html',
})
export class FilterBooleanValueComponent {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new EventEmitter<QueryFilterInstanceResource>();

  constructor(readonly I18n:I18nService) {
  }

  public get value():HalResource | string {
    return this.filter.values[0];
  }

  public onFilterUpdated(val:string | HalResource) {
    this.filter.values[0] = val;
    this.filterChanged.emit(this.filter);
  }
}

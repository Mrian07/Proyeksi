

import { Component } from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import {
  DebouncedRequestSwitchmap,
  errorNotificationHandler,
} from 'core-app/shared/helpers/rxjs/debounced-input-switchmap';
import { take } from 'rxjs/operators';
import { ApiV3FilterBuilder } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';
import { SelectEditFieldComponent } from './select-edit-field/select-edit-field.component';

@Component({
  templateUrl: './work-package-edit-field.component.html',
})
export class WorkPackageEditFieldComponent extends SelectEditFieldComponent {
  /** Keep a switchmap for search term and loading state */
  public requests = new DebouncedRequestSwitchmap<string, HalResource>(
    (searchTerm:string) => this.loadValues(searchTerm),
    errorNotificationHandler(this.halNotification),
  );

  protected initialValueLoading() {
    this.valuesLoaded = false;

    // Using this hack with the empty value to have the values loaded initially
    // while avoiding loading it multiple times.
    return new Promise<HalResource[]>((resolve) => {
      this.requests.output$.pipe(take(1)).subscribe((options) => {
        resolve(options);
      });

      this.requests.input$.next('');
    });
  }

  public get typeahead() {
    return this.requests.input$;
  }

  protected allowedValuesFilter(query?:string):{} {
    let filterParams = super.allowedValuesFilter(query);

    if (query) {
      const filters:ApiV3FilterBuilder = new ApiV3FilterBuilder();

      filters.add('subjectOrId', '**', [query]);

      filterParams = { filters: filters.toJson() };
    }

    return filterParams;
  }
}

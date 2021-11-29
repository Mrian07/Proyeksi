

import { Component, EventEmitter, Output } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageViewFiltersService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-filters.service';
import { Subject } from 'rxjs';
import {
  debounceTime, distinctUntilChanged, map, tap,
} from 'rxjs/operators';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { input } from 'reactivestates';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { QueryFilterResource } from 'core-app/features/hal/resources/query-filter-resource';

@Component({
  selector: 'wp-filter-by-text-input',
  templateUrl: './quick-filter-by-text-input.html',
})

export class WorkPackageFilterByTextInputComponent extends UntilDestroyedMixin {
  @Output() public deactivateFilter = new EventEmitter<QueryFilterResource>();

  public text = {
    createWithDropdown: this.I18n.t('js.work_packages.create.button'),
    createButton: this.I18n.t('js.label_work_package'),
    explanation: this.I18n.t('js.label_create_work_package'),
    placeholder: this.I18n.t('js.work_packages.placeholder_filter_by_text'),
  };

  /** Observable to the current search filter term */
  public searchTerm = input<string>('');

  /** Input for search requests */
  public searchTermChanged:Subject<string> = new Subject<string>();

  constructor(readonly I18n:I18nService,
    readonly querySpace:IsolatedQuerySpace,
    readonly wpTableFilters:WorkPackageViewFiltersService) {
    super();

    this.wpTableFilters
      .pristine$()
      .pipe(
        this.untilDestroyed(),
        map(() => {
          const currentSearchFilter = this.wpTableFilters.find('search');
          return currentSearchFilter ? (currentSearchFilter.values[0] as string) : '';
        }),
      )
      .subscribe((upstreamTerm:string) => {
        console.log(`upstream ${upstreamTerm} ${(this.searchTerm as any).timestampOfLastValue}`);
        if (!this.searchTerm.value || this.searchTerm.isValueOlderThan(500)) {
          console.log(`Upstream value setting to ${upstreamTerm}`);
          this.searchTerm.putValue(upstreamTerm);
        }
      });

    this.searchTermChanged
      .pipe(
        this.untilDestroyed(),
        distinctUntilChanged(),
        tap((val) => this.searchTerm.putValue(val)),
        debounceTime(500),
      )
      .subscribe((term) => {
        if (term.length > 0) {
          this.wpTableFilters.replace('search', (filter) => {
            filter.operator = filter.findOperator('**')!;
            filter.values = [term];
          });
        } else {
          const filter = this.wpTableFilters.find('search');

          this.wpTableFilters.remove(filter!);

          this.deactivateFilter.emit(filter);
        }
      });
  }
}

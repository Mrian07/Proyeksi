

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  Input,
  OnDestroy,
  OnInit,
  Output,

} from '@angular/core';
import { WorkPackageViewFiltersService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-filters.service';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { Observable } from 'rxjs';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { WorkPackageFiltersService } from 'core-app/features/work-packages/components/filters/wp-filters/wp-filters.service';

@Component({
  templateUrl: './filter-container.directive.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'filter-container',
})
export class WorkPackageFilterContainerComponent extends UntilDestroyedMixin implements OnInit, OnDestroy {
  @Input('showFilterButton') showFilterButton = false;

  @Input('filterButtonText') filterButtonText:string = I18n.t('js.button_filter');

  @Output() public filtersChanged = new DebouncedEventEmitter<QueryFilterInstanceResource[]>(componentDestroyed(this));

  public visible$:Observable<boolean>;

  public filters = this.wpTableFilters.current;

  public loaded = false;

  constructor(readonly wpTableFilters:WorkPackageViewFiltersService,
    readonly cdRef:ChangeDetectorRef,
    readonly wpFiltersService:WorkPackageFiltersService) {
    super();
    this.visible$ = this.wpFiltersService.observeUntil(componentDestroyed(this));
  }

  ngOnInit():void {
    this.wpTableFilters
      .pristine$()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe(() => {
        this.filters = this.wpTableFilters.current;
        this.loaded = true;
        this.cdRef.detectChanges();
      });
  }

  public replaceIfComplete(filters:QueryFilterInstanceResource[]) {
    const available = filters.filter((el) => this.wpTableFilters.isAvailable(el));
    this.wpTableFilters.replaceIfComplete(available);
    this.filtersChanged.emit(available);
  }
}

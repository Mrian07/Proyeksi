

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, OnDestroy, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageViewPaginationService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-pagination.service';
import { WorkPackageViewPagination } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-table-pagination';
import { WorkPackageViewSortByService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-sort-by.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { combineLatest } from 'rxjs';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';
import { TablePaginationComponent } from 'core-app/shared/components/table-pagination/table-pagination.component';
import { IPaginationOptions, PaginationService } from 'core-app/shared/components/table-pagination/pagination-service';

@Component({
  templateUrl: '../../../../../shared/components/table-pagination/table-pagination.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'wp-table-pagination',
})
export class WorkPackageTablePaginationComponent extends TablePaginationComponent implements OnInit, OnDestroy {
  constructor(protected paginationService:PaginationService,
    protected cdRef:ChangeDetectorRef,
    protected wpTablePagination:WorkPackageViewPaginationService,
    readonly querySpace:IsolatedQuerySpace,
    readonly wpTableSortBy:WorkPackageViewSortByService,
    readonly I18n:I18nService) {
    super(paginationService, cdRef, I18n);
  }

  ngOnInit() {
    this.paginationService
      .loadPaginationOptions()
      .then((paginationOptions:IPaginationOptions) => {
        this.perPageOptions = paginationOptions.perPageOptions;
        this.cdRef.detectChanges();
      });

    this.wpTablePagination
      .live$()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wpPagination:WorkPackageViewPagination) => {
        this.pagination = wpPagination.current;
        this.update();
      });

    // hide/show pagination options depending on the sort mode
    combineLatest([
      this.querySpace.query.values$(),
      this.wpTableSortBy.live$(),
    ]).pipe(
      this.untilDestroyed(),
    ).subscribe(([query, sort]) => {
      this.showPerPage = this.showPageSelections = !this.isManualSortingMode;
      this.infoText = this.paginationInfoText(query.results);

      this.update();
    });
  }

  public selectPerPage(perPage:number) {
    this.paginationService.setPerPage(perPage);
    this.wpTablePagination.updateFromObject({ page: 1, perPage });
  }

  public showPage(pageNumber:number) {
    this.wpTablePagination.updateFromObject({ page: pageNumber });
  }

  private get isManualSortingMode() {
    return this.wpTableSortBy.isManualSortingMode;
  }

  public paginationInfoText(work_packages:WorkPackageCollectionResource) {
    if (this.isManualSortingMode && (work_packages.count < work_packages.total)) {
      return I18n.t('js.work_packages.limited_results',
        { count: work_packages.count });
    }
    return undefined;
  }
}

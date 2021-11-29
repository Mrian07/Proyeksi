

import { combine } from 'reactivestates';
import { mapTo } from 'rxjs/operators';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { States } from 'core-app/core/states/states.service';
import { QuerySortByResource } from 'core-app/features/hal/resources/query-sort-by-resource';
import isPersistedResource from 'core-app/features/hal/helpers/is-persisted-resource';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { QueryColumn } from 'core-app/features/work-packages/components/wp-query/query-column';
import { WorkPackageQueryStateService } from './wp-view-base.service';

@Injectable()
export class WorkPackageViewSortByService extends WorkPackageQueryStateService<QuerySortByResource[]> {
  constructor(protected readonly states:States,
    protected readonly querySpace:IsolatedQuerySpace,
    protected readonly pathHelper:PathHelperService) {
    super(querySpace);
  }

  public valueFromQuery(query:QueryResource) {
    return [...query.sortBy];
  }

  public onReadyWithAvailable():Observable<null> {
    return combine(this.pristineState, this.querySpace.available.sortBy)
      .values$()
      .pipe(
        mapTo(null),
      );
  }

  public hasChanged(query:QueryResource) {
    const comparer = (sortBy:QuerySortByResource[]) => sortBy.map((el) => el.href);

    return !_.isEqual(
      comparer(query.sortBy),
      comparer(this.current),
    );
  }

  public applyToQuery(query:QueryResource) {
    const wasManuallySorted = this.isManuallySorted(query.sortBy);

    query.sortBy = [...this.current];

    // Reload every time unless we stayed in manual sort mode
    return !(wasManuallySorted && this.isManualSortingMode);
  }

  public isSortable(column:QueryColumn):boolean {
    return !!_.find(
      this.available,
      (candidate) => candidate.column.href === column.href,
    );
  }

  public addSortCriteria(column:QueryColumn, criteria:string) {
    const available = this.findAvailableDirection(column, criteria);

    if (available) {
      this.add(available);
    }
  }

  public setAsSingleSortCriteria(column:QueryColumn, criteria:string) {
    const available:QuerySortByResource = this.findAvailableDirection(column, criteria)!;

    if (available) {
      this.update([available]);
    }
  }

  public findAvailableDirection(column:QueryColumn, direction:string):QuerySortByResource | undefined {
    return _.find(
      this.available,
      (candidate) => (candidate.column.href === column.href
        && candidate.direction.href === direction),
    );
  }

  public add(sortBy:QuerySortByResource) {
    const newValue = _
      .uniqBy([sortBy, ...this.current], (sortBy) => sortBy.column.href)
      .slice(0, 3);

    this.update(newValue);
  }

  public get isManualSortingMode():boolean {
    return this.isManuallySorted(this.current);
  }

  public switchToManualSorting(query:QueryResource):boolean {
    const { manualSortObject } = this;
    if (manualSortObject && !this.isManualSortingMode) {
      if (query && isPersistedResource(query)) {
        // Save the query if it is persisted
        query.sortBy = [manualSortObject];
        return true;
      }
      // Query cannot be saved, just update the props for now
      this.update([manualSortObject]);
    }

    return false;
  }

  public get current():QuerySortByResource[] {
    return this.lastUpdatedState.getValueOr([]);
  }

  private get availableState() {
    return this.querySpace.available.sortBy;
  }

  public get available():QuerySortByResource[] {
    return this.availableState.getValueOr([]);
  }

  private isManuallySorted(sortBy:QuerySortByResource[]):boolean {
    if (sortBy && sortBy.length > 0) {
      return sortBy[0].column.href!.endsWith('/manualSorting');
    }

    return false;
  }

  private get manualSortObject() {
    return _.find(this.available, (sort) => sort.column.href!.endsWith('/manualSorting'));
  }
}

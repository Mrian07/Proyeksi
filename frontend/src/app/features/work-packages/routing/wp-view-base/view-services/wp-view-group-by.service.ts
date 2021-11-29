

import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { States } from 'core-app/core/states/states.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { Injectable } from '@angular/core';
import { QueryColumn } from 'core-app/features/work-packages/components/wp-query/query-column';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { QueryGroupByResource } from 'core-app/features/hal/resources/query-group-by-resource';
import { WorkPackageQueryStateService } from './wp-view-base.service';

@Injectable()
export class WorkPackageViewGroupByService extends WorkPackageQueryStateService<QueryGroupByResource|null> {
  public constructor(readonly states:States,
    readonly querySpace:IsolatedQuerySpace) {
    super(querySpace);
  }

  valueFromQuery(query:QueryResource) {
    return query.groupBy || null;
  }

  public hasChanged(query:QueryResource) {
    const comparer = (groupBy:QueryColumn|HalResource|null|undefined) => (groupBy ? groupBy.href : null);

    return !_.isEqual(
      comparer(query.groupBy),
      comparer(this.current),
    );
  }

  public applyToQuery(query:QueryResource) {
    const { current } = this;
    query.groupBy = current === null ? undefined : current;
    return true;
  }

  public isGroupable(column:QueryColumn):boolean {
    return !!_.find(this.available, (candidate) => candidate.id === column.id);
  }

  public disable() {
    this.update(null);
  }

  public setBy(column:QueryColumn) {
    const groupBy = _.find(this.available, (candidate) => candidate.id === column.id);

    if (groupBy) {
      this.update(groupBy);
    }
  }

  public get current():QueryGroupByResource|null {
    return this.lastUpdatedState.getValueOr(null);
  }

  protected get availableState() {
    return this.querySpace.available.groupBy;
  }

  public get isEnabled():boolean {
    return !!this.current;
  }

  public get available():QueryGroupByResource[] {
    return this.availableState.getValueOr([]);
  }

  public isCurrentlyGroupedBy(column:QueryColumn):boolean {
    const cur = this.current;
    return !!(cur && cur.id === column.id);
  }
}

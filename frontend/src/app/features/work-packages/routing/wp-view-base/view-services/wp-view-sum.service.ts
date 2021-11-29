

import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { Injectable } from '@angular/core';
import { WorkPackageQueryStateService } from './wp-view-base.service';

@Injectable()
export class WorkPackageViewSumService extends WorkPackageQueryStateService<boolean> {
  public constructor(querySpace:IsolatedQuerySpace) {
    super(querySpace);
  }

  public valueFromQuery(query:QueryResource) {
    return !!query.sums;
  }

  public initialize(query:QueryResource) {
    this.pristineState.putValue(!!query.sums);
  }

  public hasChanged(query:QueryResource) {
    return query.sums !== this.isEnabled;
  }

  public applyToQuery(query:QueryResource) {
    query.sums = this.isEnabled;
    return true;
  }

  public toggle() {
    this.updatesState.putValue(!this.current);
  }

  public setEnabled(value:boolean) {
    this.updatesState.putValue(value);
  }

  public get isEnabled() {
    return this.current;
  }

  public get current():boolean {
    return this.lastUpdatedState.getValueOr(false);
  }
}

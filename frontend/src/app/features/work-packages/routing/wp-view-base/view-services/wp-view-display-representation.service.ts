

import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { States } from 'core-app/core/states/states.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { Injectable } from '@angular/core';
import { WorkPackageQueryStateService } from './wp-view-base.service';

export const wpDisplayListRepresentation = 'list';
export const wpDisplayCardRepresentation = 'card';
export type WorkPackageDisplayRepresentationValue = 'list'|'card';

@Injectable()
export class WorkPackageViewDisplayRepresentationService extends WorkPackageQueryStateService<string|null> {
  public constructor(readonly states:States,
    readonly querySpace:IsolatedQuerySpace) {
    super(querySpace);
  }

  public hasChanged(query:QueryResource) {
    return this.current !== query.displayRepresentation;
  }

  valueFromQuery(query:QueryResource) {
    return query.displayRepresentation || null;
  }

  public applyToQuery(query:QueryResource) {
    const { current } = this;
    query.displayRepresentation = current === null ? undefined : current;

    return false;
  }

  public get current():string|null {
    return this.lastUpdatedState.getValueOr(null);
  }

  public get isList():boolean {
    const { current } = this;
    return !current || current === wpDisplayListRepresentation;
  }

  public get isCards():boolean {
    return this.current === wpDisplayCardRepresentation;
  }

  public setDisplayRepresentation(representation:WorkPackageDisplayRepresentationValue) {
    this.update(representation);
  }
}

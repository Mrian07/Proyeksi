

import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import {
  combine, deriveRaw, input, State,
} from 'reactivestates';
import { map, mapTo, take } from 'rxjs/operators';
import { merge, Observable } from 'rxjs';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { Injectable } from '@angular/core';
import { QuerySchemaResource } from 'core-app/features/hal/resources/query-schema-resource';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';

@Injectable()
export abstract class WorkPackageViewBaseService<T> {
  /** Internal state to push non-persisted updates */
  protected updatesState = input<T>();

  /** Internal pristine state filled during +initialize+ only */
  protected pristineState = input<T>();

  constructor(protected readonly querySpace:IsolatedQuerySpace) {
  }

  /**
   * Get the state value from the current query.
   *
   * @param {QueryResource} query
   * @returns {T} Instance of the state value for this type.
   */
  public abstract valueFromQuery(query:QueryResource, results:WorkPackageCollectionResource):T|undefined;

  /**
   * Initialize this table state from the given query resource,
   * and possibly the associated schema.
   *
   * @param {QueryResource} querywp-view-group-by.service
   * @param {QuerySchemaResource} schema
   */
  public initialize(query:QueryResource, results:WorkPackageCollectionResource, schema?:QuerySchemaResource) {
    const initial = this.valueFromQuery(query, results)!;
    this.pristineState.putValue(initial);
  }

  public update(value:T) {
    this.updatesState.putValue(value);
  }

  public clear(reason:string) {
    this.pristineState.clear(reason);
    this.updatesState.clear(reason);
  }

  /**
   * Get the combined pristine and update value changes
   * @param unsubscribe
   */
  public live$():Observable<T> {
    return merge(
      this.pristineState.values$(),
      this.updatesState.values$(),
    );
  }

  /**
   * Get pristine upstream changes
   *
   * @param unsubscribe
   */
  public pristine$():Observable<T> {
    return this
      .pristineState
      .values$();
  }

  /**
   * Get only the local update changes
   *
   * @param unsubscribe
   */
  public updates$():Observable<T> {
    return this
      .updatesState
      .values$();
  }

  /**
   * Get only the local update changes
   *
   * @param unsubscribe
   */
  public changes$():Observable<unknown> {
    return this
      .updatesState
      .changes$();
  }

  public onReady() {
    return this
      .pristineState
      .values$()
      .pipe(
        take(1),
        mapTo(null),
      )
      .toPromise();
  }

  /** Get the last updated value from either pristine or update state */
  protected get lastUpdatedState():State<T> {
    const combinedRaw = combine(this.pristineState, this.updatesState);

    return deriveRaw(combinedRaw,
      ($) => $
        .pipe(
          map(([pristine, current]) => {
            if (current === undefined) {
              return pristine;
            }
            return current;
          }),
        ));
  }

  /**
   * Helper to set the value of the current state
   * @param val
   */
  protected set current(val:T|undefined) {
    if (val) {
      this.updatesState.putValue(val);
    } else {
      this.updatesState.clear();
    }
  }

  /**
   * Get the value of the current state, if any.
   */
  protected get current():T|undefined {
    return this.lastUpdatedState.value;
  }
}

@Injectable()
export abstract class WorkPackageQueryStateService<T> extends WorkPackageViewBaseService<T> {
  /**
   * Check whether the state value does not match the query resource's value.
   * @param query The current query resource
   */
  abstract hasChanged(query:QueryResource):boolean;

  /**
   * Apply the current state value to query
   *
   * @return Whether the query should be visibly updated.
   */
  abstract applyToQuery(query:QueryResource):boolean;
}

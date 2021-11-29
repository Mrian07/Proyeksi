

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { States } from 'core-app/core/states/states.service';
import { HasId, StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { concat, Observable, of } from 'rxjs';
import {
  mapTo, shareReplay, switchMap, take, tap,
} from 'rxjs/operators';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export abstract class CachableAPIV3Resource<T extends HasId = HalResource>
  extends APIv3GettableResource<T> {
  @InjectField() states:States;

  @InjectField() schemaCache:SchemaCacheService;

  readonly cache = this.createCache();

  /**
   * Require the value to be loaded either when forced or the value is stale
   * according to the cache interval specified for this service.
   *
   * Returns an observable to the values stream of the state.
   *
   * @param force Load the value anyway.
   */
  public requireAndStream(force = false):Observable<T> {
    const id = this.id.toString();

    // Refresh when stale or being forced
    if (this.cache.stale(id) || force) {
      const observable = this
        .load()
        .pipe(
          take(1),
          shareReplay(1),
        );

      this.cache.clearAndLoad(
        id,
        observable,
      );

      // Return concat of the loading observable
      // for error handling and the like,
      // but then continue with the streamed cache
      return concat<T>(
        observable,
        this.cache.state(id).values$(),
      );
    }

    return this.cache.state(id).values$();
  }

  /**
   * Observe the values of this resource,
   * but do not request it actively.
   */
  public observe():Observable<T> {
    return this
      .cache
      .observe(this.id.toString());
  }

  /**
   * Returns a (potentially cached) observable.
   *
   * Only observes one value.
   *
   * Accesses or modifies the global store for this resource.
   */
  get():Observable<T> {
    return this
      .requireAndStream(false)
      .pipe(
        take(1),
      );
  }

  /**
   * Returns a freshly loaded value but ensuring the value
   * is also updated in the cache.
   *
   * Only observes one value.
   *
   * Accesses or modifies the global store for this resource.
   */
  refresh():Promise<T> {
    return this
      .requireAndStream(true)
      .pipe(
        take(1),
      )
      // Use a promise to ensure this fires
      // even if caller isn't subscribing.
      .toPromise();
  }

  /**
   * Perform a request to the HalResourceService with the current path
   */
  protected load():Observable<T> {
    return this
      .halResourceService
      .get(this.path)
      .pipe(
        switchMap((resource) => {
          if (resource.$links.schema) {
            return this.schemaCache
              .requireAndStream(resource.$links.schema.href)
              .pipe(
                take(1),
                mapTo(resource),
              );
          }
          return of(resource);
        }),
      ) as any; // T does not extend HalResource for virtual endpoints such as board, thus we need to cast here
  }

  /**
   * Update a single resource
   */
  protected touch(resource:T):void {
    this.cache.updateFor(resource);
  }

  /**
   * Inserts a collection response to cache as an rxjs tap function
   */
  protected cacheResponse():(source:Observable<T>) => Observable<T> {
    return (source$:Observable<T>) => source$.pipe(
      tap(
        (resource:T) => this.touch(resource),
      ),
    );
  }

  /**
   * Creates the cache state instance
   */
  protected abstract createCache():StateCacheService<T>;
}

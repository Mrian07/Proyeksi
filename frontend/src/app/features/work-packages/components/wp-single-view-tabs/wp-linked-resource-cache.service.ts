

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { input, InputState } from 'reactivestates';
import { take } from 'rxjs/operators';
import { Observable, of } from 'rxjs';
import { EntityUIStore } from '@datorama/akita';

EntityUIStore;

export abstract class WorkPackageLinkedResourceCache<T> {
  protected cacheDurationInSeconds = 120;

  // Cache activities for the last work package
  // to allow fast switching between work packages without refreshing.
  protected cache:{ id:string|null, state:InputState<T> } = {
    id: null,
    state: input<T>(),
  };

  /**
   * Requires the linked resource for the given work package.
   * Caches a single value for subsequent requests for +cacheDurationInSeconds+ seconds.
   *
   * Whenever another work package's linked resource is requested, the cache is replaced.
   *
   * @param {WorkPackageResource} workPackage
   * @returns {Promise<T>}
   */
  public requireAndStream(workPackage:WorkPackageResource, force = false):Observable<T> {
    const id = workPackage.id!;
    const { state } = this.cache;

    // Clear cache if requesting different resource
    if (force || this.cache.id !== id) {
      state.clear();
    }

    // Return cached value if id matches and value is present
    if (this.isCached(id)) {
      return of(state.value!);
    }

    // Ensure value is loaded only once
    this.cache.id = id;
    this.cache.state.putFromPromiseIfPristine(() => this.load(workPackage));

    return this.cache.state.values$();
  }

  public require(workPackage:WorkPackageResource, force = false):Promise<T> {
    return this
      .requireAndStream(workPackage, force)
      .pipe(
        take(1),
      )
      .toPromise();
  }

  public clear(workPackageId:string|null) {
    if (this.cache.id === workPackageId) {
      this.cache.state.clear();
    }
  }

  /**
   * Return whether the given work package is cached.
   * @param {string} workPackageId
   * @returns {boolean}
   */
  public isCached(workPackageId:string) {
    const { state } = this.cache;
    return this.cache.id === workPackageId && state.hasValue() && !state.isValueOlderThan(this.cacheDurationInSeconds * 1000);
  }

  /**
   * Load the linked resource and return it as a promise
   * @param {WorkPackageResource} workPackage
   */
  protected abstract load(workPackage:WorkPackageResource):Promise<T>;
}

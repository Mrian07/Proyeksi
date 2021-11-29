

import { VersionResource } from 'core-app/features/hal/resources/version-resource';
import { Observable } from 'rxjs';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { tap } from 'rxjs/operators';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class APIv3VersionPaths extends CachableAPIV3Resource<VersionResource> {
  /**
   * Update a version resource with the given payload
   *
   * @param resource
   * @param payload
   */
  public patch(payload:Object):Observable<VersionResource> {
    return this
      .halResourceService
      .patch<VersionResource>(
      this.path,
      payload,
    )
      .pipe(
        tap((version) => this.touch(version)),
      );
  }

  protected createCache():StateCacheService<VersionResource> {
    return new StateCacheService<VersionResource>(this.states.versions);
  }
}

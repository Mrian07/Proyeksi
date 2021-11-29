

import { Apiv3TimeEntryPaths } from 'core-app/core/apiv3/endpoints/time-entries/apiv3-time-entry-paths';
import { TimeEntryResource } from 'core-app/features/hal/resources/time-entry-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';
import { Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { CachableAPIV3Collection } from 'core-app/core/apiv3/cache/cachable-apiv3-collection';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { TimeEntryCacheService } from 'core-app/core/apiv3/endpoints/time-entries/time-entry-cache.service';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class Apiv3TimeEntriesPaths
  extends CachableAPIV3Collection<TimeEntryResource, Apiv3TimeEntryPaths>
  implements Apiv3ListResourceInterface<TimeEntryResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'time_entries', Apiv3TimeEntryPaths);
  }

  // Static paths
  public readonly form = this.subResource('form', APIv3FormResource);

  /**
   * Load a list of time entries with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<TimeEntryResource>> {
    return this
      .halResourceService
      .get<CollectionResource<TimeEntryResource>>(this.path + listParamsString(params))
      .pipe(
        this.cacheResponse(),
      );
  }

  /**
   * Create a time entry resource from the given payload
   * @param payload
   */
  public post(payload:Object):Observable<TimeEntryResource> {
    return this
      .halResourceService
      .post<TimeEntryResource>(this.path, payload)
      .pipe(
        this.cacheResponse(),
      );
  }

  protected createCache():StateCacheService<TimeEntryResource> {
    return new TimeEntryCacheService(this.injector, this.states.timeEntries);
  }
}

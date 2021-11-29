

import { TimeEntryResource } from 'core-app/features/hal/resources/time-entry-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Apiv3TimeEntriesPaths } from 'core-app/core/apiv3/endpoints/time-entries/apiv3-time-entries-paths';
import { HalPayloadHelper } from 'core-app/features/hal/schemas/hal-payload.helper';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class Apiv3TimeEntryPaths extends CachableAPIV3Resource<TimeEntryResource> {
  // Static paths
  readonly form = this.subResource('form', APIv3FormResource);

  /**
   * Update the time entry with the given payload.
   *
   * In case of updating from the hal resource, a schema resource is needed
   * to identify the writable attributes.
   * @param payload
   * @param schema
   */
  public patch(payload:Object, schema:SchemaResource|null = null):Observable<TimeEntryResource> {
    return this
      .halResourceService
      .patch<TimeEntryResource>(this.path, this.extractPayload(payload, schema))
      .pipe(
        tap((resource) => this.touch(resource)),
      );
  }

  /**
   * Delete the time entry under the current path
   */
  public delete():Observable<unknown> {
    return this
      .halResourceService
      .delete<TimeEntryResource>(this.path)
      .pipe(
        tap(() => this.cache.clearSome(this.id.toString())),
      );
  }

  protected createCache():StateCacheService<TimeEntryResource> {
    return (this.parent as Apiv3TimeEntriesPaths).cache;
  }

  /**
   * Extract payload from the given request with schema.
   * This will ensure we will only write writable attributes and so on.
   *
   * @param resource
   * @param schema
   */
  protected extractPayload(resource:HalResource|Object|null, schema:SchemaResource|null = null) {
    if (resource instanceof HalResource && schema) {
      return HalPayloadHelper.extractPayloadFromSchema(resource, schema);
    } if (!(resource instanceof HalResource)) {
      return resource;
    }
    return {};
  }
}
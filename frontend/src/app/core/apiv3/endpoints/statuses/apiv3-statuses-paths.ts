

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { StatusResource } from 'core-app/features/hal/resources/status-resource';
import { APIv3StatusPaths } from 'core-app/core/apiv3/endpoints/statuses/apiv3-status-paths';
import { Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { tap } from 'rxjs/operators';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

export class APIv3StatusesPaths extends APIv3ResourceCollection<StatusResource, APIv3StatusPaths> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'statuses', APIv3StatusPaths);
  }

  /**
   * Perform a request to the HalResourceService with the current path
   */
  public get():Observable<CollectionResource<StatusResource>> {
    return this
      .halResourceService
      .get<CollectionResource<StatusResource>>(this.path)
      .pipe(
        tap((collection) => {
          collection.elements.forEach((resource, id) => {
            this.id(resource.id!).cache.updateValue(resource.id!, resource);
          });
        }),
      );
  }
}

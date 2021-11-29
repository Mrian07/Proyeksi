

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { RoleResource } from 'core-app/features/hal/resources/role-resource';
import { APIv3RolePaths } from 'core-app/core/apiv3/endpoints/roles/apiv3-role-paths';
import { Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { tap } from 'rxjs/operators';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

export class APIv3RolesPaths extends APIv3ResourceCollection<RoleResource, APIv3RolePaths> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'roles', APIv3RolePaths);
  }

  /**
   * Perform a request to the HalResourceService with the current path
   */
  public get():Observable<CollectionResource<RoleResource>> {
    return this
      .halResourceService
      .get<CollectionResource<RoleResource>>(this.path)
      .pipe(
        tap((collection) => {
          collection.elements.forEach((resource, id) => {
            this.id(resource.id!).cache.updateValue(resource.id!, resource);
          });
        }),
      );
  }
}

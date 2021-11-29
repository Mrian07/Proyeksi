

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { Apiv3PlaceholderUserPaths } from 'core-app/core/apiv3/endpoints/placeholder-users/apiv3-placeholder-user-paths';
import { PlaceholderUserResource } from 'core-app/features/hal/resources/placeholder-user-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';

export class Apiv3PlaceholderUsersPaths
  extends APIv3ResourceCollection<PlaceholderUserResource, Apiv3PlaceholderUserPaths>
  implements Apiv3ListResourceInterface<PlaceholderUserResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'placeholder_users', Apiv3PlaceholderUserPaths);
  }

  /**
   * Load a list of placeholder users with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<PlaceholderUserResource>> {
    return this
      .halResourceService
      .get<CollectionResource<PlaceholderUserResource>>(this.path + listParamsString(params));
  }

  /**
   * Create a new PlaceholderUserResource
   *
   * @param resource
   */
  public post(resource:{ name:string }):Observable<PlaceholderUserResource> {
    return this
      .halResourceService
      .post<PlaceholderUserResource>(
      this.path,
      resource,
    );
  }
}

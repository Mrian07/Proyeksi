

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { Apiv3GroupPaths } from 'core-app/core/apiv3/endpoints/groups/apiv3-group-paths';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { GroupResource } from 'core-app/features/hal/resources/group-resource';

export class Apiv3GroupsPaths
  extends APIv3ResourceCollection<GroupResource, Apiv3GroupPaths>
  implements Apiv3ListResourceInterface<GroupResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'groups', Apiv3GroupPaths);
  }

  /**
   * Load a list of placeholder users with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<GroupResource>> {
    return this
      .halResourceService
      .get<CollectionResource<GroupResource>>(this.path + listParamsString(params));
  }

  /**
   * Create a new GroupResource
   *
   * @param resource
   */
  public post(resource:{ name:string }):Observable<GroupResource> {
    return this
      .halResourceService
      .post<GroupResource>(
      this.path,
      resource,
    );
  }
}

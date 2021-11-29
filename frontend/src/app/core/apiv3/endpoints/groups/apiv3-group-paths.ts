

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { GroupResource } from 'core-app/features/hal/resources/group-resource';
import { Observable } from 'rxjs';

export class Apiv3GroupPaths extends APIv3GettableResource<GroupResource> {
  /**
   * Update a placeholder user resource or payload
   * @param resource
   */
  public patch(resource:GroupResource|{ name:string }):Observable<GroupResource> {
    return this
      .halResourceService
      .patch<GroupResource>(this.path, {
      name: resource.name,
    });
  }

  /**
   * Delete a placeholder user resource
   */
  public delete():Observable<unknown> {
    return this
      .halResourceService
      .delete(this.path);
  }
}

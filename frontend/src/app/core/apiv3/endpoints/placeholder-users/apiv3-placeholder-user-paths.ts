

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { PlaceholderUserResource } from 'core-app/features/hal/resources/placeholder-user-resource';
import { Observable } from 'rxjs';

export class Apiv3PlaceholderUserPaths extends APIv3GettableResource<PlaceholderUserResource> {
  /**
   * Update a placeholder user resource or payload
   * @param resource
   */
  public patch(resource:PlaceholderUserResource|{ name:string }):Observable<PlaceholderUserResource> {
    return this
      .halResourceService
      .patch<PlaceholderUserResource>(this.path, {
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

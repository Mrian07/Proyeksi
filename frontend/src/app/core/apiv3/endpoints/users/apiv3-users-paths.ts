

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { APIv3UserPaths } from 'core-app/core/apiv3/endpoints/users/apiv3-user-paths';
import { Observable } from 'rxjs';
import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';

export class Apiv3UsersPaths extends APIv3ResourceCollection<UserResource, APIv3UserPaths> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'users', APIv3UserPaths);
  }

  // Static paths

  // /api/v3/users/me
  public readonly me = this.subResource('me', APIv3UserPaths);

  // /api/v3/users/form
  public readonly form = this.subResource('form', APIv3FormResource);

  /**
   * Create a new UserResource
   *
   * @param resource
   */
  public post(resource:{
    // TODO: The typing here could be a lot better
    login?:string,
    firstName?:string,
    lastName?:string,
    email?:string,
    admin?:boolean,
    language?:string,
    password?:string,
    auth_source?:string,
    identity_url?:string,
    status:'invited'|'active',
  }):Observable<UserResource> {
    return this
      .halResourceService
      .post<UserResource>(
      this.path,
      resource,
    );
  }
}

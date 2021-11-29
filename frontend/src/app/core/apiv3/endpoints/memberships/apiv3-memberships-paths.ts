

import { APIv3GettableResource, APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Apiv3AvailableProjectsPaths } from 'core-app/core/apiv3/endpoints/projects/apiv3-available-projects-paths';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { Observable } from 'rxjs';
import { Apiv3MembershipsForm } from 'core-app/core/apiv3/endpoints/memberships/apiv3-memberships-form';
import { MembershipResource, MembershipResourceEmbedded } from 'core-app/features/hal/resources/membership-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';

export class Apiv3MembershipsPaths
  extends APIv3ResourceCollection<MembershipResource, APIv3GettableResource<MembershipResource>>
  implements Apiv3ListResourceInterface<MembershipResource> {
  // Static paths
  readonly form = this.subResource('form', Apiv3MembershipsForm);

  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'memberships');
  }

  /**
   * Load a list of membership entries with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<MembershipResource>> {
    return this
      .halResourceService
      .get<CollectionResource<MembershipResource>>(this.path + listParamsString(params));
  }

  // /api/v3/memberships/available_projects
  readonly available_projects = this.subResource('available_projects', Apiv3AvailableProjectsPaths);

  /**
   * Create a new MembershipResource
   *
   * @param resource
   */
  public post(resource:MembershipResourceEmbedded):Observable<MembershipResource> {
    const payload = this.form.extractPayload(resource);
    return this
      .halResourceService
      .post<MembershipResource>(
      this.path,
      payload,
    );
  }
}

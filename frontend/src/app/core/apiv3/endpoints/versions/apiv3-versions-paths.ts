

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { VersionResource } from 'core-app/features/hal/resources/version-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';
import { Observable } from 'rxjs';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { Apiv3AvailableProjectsPaths } from 'core-app/core/apiv3/endpoints/projects/apiv3-available-projects-paths';
import { APIv3VersionPaths } from 'core-app/core/apiv3/endpoints/versions/apiv3-version-paths';

export class APIv3VersionsPaths extends APIv3ResourceCollection<VersionResource, APIv3VersionPaths> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'versions', APIv3VersionPaths);
  }

  // /api/v3/versions/form
  public readonly form = this.subResource('form', APIv3FormResource);

  public readonly available_projects = this.subResource('available_projects', Apiv3AvailableProjectsPaths);

  /**
   * Get all versions
   */
  public get():Observable<CollectionResource<VersionResource>> {
    return this
      .halResourceService
      .get<CollectionResource<VersionResource>>(this.path);
  }

  /**
   * Create a version from the given payload
   *
   * @param payload
   * @return {Promise<WorkPackageResource>}
   */
  public post(payload:Object):Observable<VersionResource> {
    return this
      .halResourceService
      .post<VersionResource>(this.path, payload);
  }
}

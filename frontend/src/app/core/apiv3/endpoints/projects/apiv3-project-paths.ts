

import { APIv3QueriesPaths } from 'core-app/core/apiv3/endpoints/queries/apiv3-queries-paths';
import { APIv3TypesPaths } from 'core-app/core/apiv3/endpoints/types/apiv3-types-paths';
import { APIV3WorkPackagesPaths } from 'core-app/core/apiv3/endpoints/work_packages/api-v3-work-packages-paths';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { APIv3VersionsPaths } from 'core-app/core/apiv3/endpoints/versions/apiv3-versions-paths';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { APIv3ProjectsPaths } from 'core-app/core/apiv3/endpoints/projects/apiv3-projects-paths';
import { APIv3ProjectCopyPaths } from 'core-app/core/apiv3/endpoints/projects/apiv3-project-copy-paths';

export class APIv3ProjectPaths extends CachableAPIV3Resource<ProjectResource> {
  // /api/v3/projects/:project_id/available_assignees
  public readonly available_assignees = this.subResource('available_assignees');

  // /api/v3/projects/:project_id/queries
  public readonly queries = new APIv3QueriesPaths(this.apiRoot, this.path);

  // /api/v3/projects/:project_id/types
  public readonly types = new APIv3TypesPaths(this.apiRoot, this.path);

  // /api/v3/projects/:project_id/work_packages
  public readonly work_packages = new APIV3WorkPackagesPaths(this.apiRoot, this.path);

  // /api/v3/projects/:project_id/versions
  public readonly versions = new APIv3VersionsPaths(this.apiRoot, this.path);

  // /api/v3/projects/:project_id/copy
  public readonly copy = new APIv3ProjectCopyPaths(this.apiRoot, this.path);

  protected createCache():StateCacheService<ProjectResource> {
    return (this.parent as APIv3ProjectsPaths).cache;
  }
}

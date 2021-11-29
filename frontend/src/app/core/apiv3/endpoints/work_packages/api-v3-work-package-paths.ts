

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { Apiv3RelationsPaths } from 'core-app/core/apiv3/endpoints/relations/apiv3-relations-paths';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { APIV3WorkPackagesPaths } from 'core-app/core/apiv3/endpoints/work_packages/api-v3-work-packages-paths';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class APIV3WorkPackagePaths extends CachableAPIV3Resource<WorkPackageResource> {
  // /api/v3/(?:projectPath)/work_packages/(:workPackageId)/relations
  public readonly relations = this.subResource('relations', Apiv3RelationsPaths);

  // /api/v3/(?:projectPath)/work_packages/(:workPackageId)/revisions
  public readonly revisions = this.subResource('revisions');

  // /api/v3/(?:projectPath)/work_packages/(:workPackageId)/activities
  public readonly activities = this.subResource('activities');

  // /api/v3/(?:projectPath)/work_packages/(:workPackageId)/available_watchers
  public readonly available_watchers = this.subResource('available_watchers');

  // /api/v3/(?:projectPath)/work_packages/(:workPackageId)/available_projects
  public readonly available_projects = this.subResource('available_projects');

  // /api/v3/(?:projectPath)/work_packages/(:workPackageId)/github_pull_requests
  public readonly github_pull_requests = this.subResource('github_pull_requests');

  protected createCache():StateCacheService<WorkPackageResource> {
    return (this.parent as APIV3WorkPackagesPaths).cache;
  }
}

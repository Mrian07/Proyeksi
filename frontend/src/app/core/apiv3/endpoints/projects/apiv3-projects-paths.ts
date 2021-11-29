

import { APIv3ProjectPaths } from 'core-app/core/apiv3/endpoints/projects/apiv3-project-paths';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { Observable } from 'rxjs';
import { CachableAPIV3Collection } from 'core-app/core/apiv3/cache/cachable-apiv3-collection';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { ProjectCache } from 'core-app/core/apiv3/endpoints/projects/project.cache';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';

export class APIv3ProjectsPaths
  extends CachableAPIV3Collection<ProjectResource, APIv3ProjectPaths>
  implements Apiv3ListResourceInterface<ProjectResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'projects', APIv3ProjectPaths);
  }

  // /api/v3/projects/schema
  public readonly schema = this.subResource<SchemaResource>('schema');

  /**
   * Load a list of project with a given list parameter filter
   *
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<ProjectResource>> {
    return this
      .halResourceService
      .get<CollectionResource<ProjectResource>>(this.path + listParamsString(params))
      .pipe(
        this.cacheResponse(),
      );
  }

  protected createCache():StateCacheService<ProjectResource> {
    return new ProjectCache(this.injector, this.states.projects);
  }
}

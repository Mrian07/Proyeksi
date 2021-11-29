

import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { buildApiV3Filter } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';

export class Apiv3AvailableProjectsPaths
  extends APIv3GettableResource<CollectionResource<ProjectResource>>
  implements Apiv3ListResourceInterface<ProjectResource> {
  /**
   * Load a list of available projects with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<ProjectResource>> {
    return this
      .halResourceService
      .get<CollectionResource<ProjectResource>>(this.path + listParamsString(params));
  }

  /**
   * Performs a request against the available_projects endpoint
   * to see whether this is contained
   *
   * Returns whether the given id exists in the set
   * of available projects
   *
   * @param projectId
   */
  public exists(projectId:string):Observable<boolean> {
    return this
      .halResourceService
      .get<CollectionResource<ProjectResource>>(
      this.path,
      { filters: buildApiV3Filter('id', '=', [projectId]).toJson() },
    )
      .pipe(
        map((collection) => collection.count > 0),
      );
  }
}

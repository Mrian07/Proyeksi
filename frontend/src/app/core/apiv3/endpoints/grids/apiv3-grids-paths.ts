

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { Apiv3GridPaths } from 'core-app/core/apiv3/endpoints/grids/apiv3-grid-paths';
import { GridResource } from 'core-app/features/hal/resources/grid-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { Apiv3GridForm } from 'core-app/core/apiv3/endpoints/grids/apiv3-grid-form';
import { Observable } from 'rxjs';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';

export class Apiv3GridsPaths
  extends APIv3ResourceCollection<GridResource, Apiv3GridPaths>
  implements Apiv3ListResourceInterface<GridResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'grids', Apiv3GridPaths);
  }

  readonly form = this.subResource('form', Apiv3GridForm);

  /**
   * Load a list of grids with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<GridResource>> {
    return this
      .halResourceService
      .get<CollectionResource<GridResource>>(this.path + listParamsString(params));
  }

  /**
   * Create a new GridResource
   *
   * @param resource
   * @param schema
   */
  public post(resource:GridResource, schema:SchemaResource|null = null):Observable<GridResource> {
    return this
      .halResourceService
      .post<GridResource>(
      this.path,
      this.form.extractPayload(resource, schema),
    );
  }
}

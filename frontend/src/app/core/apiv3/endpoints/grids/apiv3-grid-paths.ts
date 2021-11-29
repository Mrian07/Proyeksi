

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { GridResource } from 'core-app/features/hal/resources/grid-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { Observable } from 'rxjs';
import { Apiv3GridForm } from 'core-app/core/apiv3/endpoints/grids/apiv3-grid-form';

export class Apiv3GridPaths extends APIv3GettableResource<GridResource> {
  // Static paths
  readonly form = this.subResource('form', Apiv3GridForm);

  /**
   * Update a grid resource or payload
   * @param resource
   * @param schema
   */
  public patch(resource:GridResource|Object, schema:SchemaResource|null = null):Observable<GridResource> {
    const payload = this.form.extractPayload(resource, schema);

    return this
      .halResourceService
      .patch<GridResource>(this.path, payload);
  }

  /**
   * Delete a grid resource
   */
  public delete():Observable<unknown> {
    return this
      .halResourceService
      .delete(this.path);
  }
}



import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { APIV3QueryOrder } from 'core-app/core/apiv3/endpoints/queries/apiv3-query-order';
import { Apiv3QueryForm } from 'core-app/core/apiv3/endpoints/queries/apiv3-query-form';
import { Observable } from 'rxjs';
import { QueryFormResource } from 'core-app/features/hal/resources/query-form-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { QueryFiltersService } from 'core-app/features/work-packages/components/wp-query/query-filters.service';
import { HalPayloadHelper } from 'core-app/features/hal/schemas/hal-payload.helper';
import { PaginationObject } from 'core-app/shared/components/table-pagination/pagination-service';

export class APIv3QueryPaths extends APIv3GettableResource<QueryResource> {
  @InjectField() private queryFilters:QueryFiltersService;

  // Static paths
  readonly form = this.subResource('form', Apiv3QueryForm);

  // Order path
  readonly order = new APIV3QueryOrder(this.injector, this.path, 'order');

  /**
   * Stream the response for the given query request
   * @param queryData
   */
  public parameterised(params:Object):Observable<QueryResource> {
    return this.halResourceService
      .get<QueryResource>(this.path, params);
  }

  /**
   * Update the given query
   * @param query
   * @param form
   */
  public patch(payload:QueryResource|Object, form?:QueryFormResource):Observable<QueryResource> {
    if (payload instanceof QueryResource && form) {
      // Extracting requires having the filter schemas loaded as the dependencies
      this.queryFilters.mapSchemasIntoFilters(payload, form);
      payload = HalPayloadHelper.extractPayloadFromSchema(payload, form.schema);
    }

    return this
      .halResourceService
      .patch<QueryResource>(this.path, payload);
  }

  /**
   * Delete the query
   */
  public delete() {
    return this
      .halResourceService
      .delete(this.path);
  }

  /**
   * Reload with a given pagination
   * @param pagination
   */
  public paginated(pagination:PaginationObject):Observable<QueryResource> {
    return this.parameterised(pagination);
  }
}
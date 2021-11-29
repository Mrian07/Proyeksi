

import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { Observable } from 'rxjs';
import { ApiV3FilterBuilder, FilterOperator } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';

export type ApiV3ListFilter = [string, FilterOperator, boolean|string[]];

export interface Apiv3ListParameters {
  filters?:ApiV3ListFilter[];
  sortBy?:[string, string][];
  groupBy?:string;
  pageSize?:number;
  offset?:number;
}

export interface Apiv3ListResourceInterface<T> {
  list(params:Apiv3ListParameters):Observable<CollectionResource<T>>;
}

export function listParamsString(params?:Apiv3ListParameters):string {
  const queryProps = [];

  if (params && params.sortBy) {
    queryProps.push(`sortBy=${JSON.stringify(params.sortBy)}`);
  }

  if (params && params.groupBy) {
    queryProps.push(`groupBy=${params.groupBy}`);
  }

  // 0 should not be treated as false
  if (params && params.pageSize !== undefined) {
    queryProps.push(`pageSize=${params.pageSize}`);
  }

  // 0 should not be treated as false
  if (params && params.offset !== undefined) {
    queryProps.push(`offset=${params.offset}`);
  }

  if (params && params.filters) {
    const filters = new ApiV3FilterBuilder();

    params.filters.forEach((filterParam) => {
      filters.add(...filterParam);
    });

    queryProps.push(filters.toParams());
  }

  let queryPropsString = '';

  if (queryProps.length) {
    queryPropsString = `?${queryProps.join('&')}`;
  }

  return queryPropsString;
}

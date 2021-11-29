

import { QueryColumn } from 'core-app/features/work-packages/components/wp-query/query-column';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export const QUERY_SORT_BY_ASC = 'urn:openproject-org:api:v3:queries:directions:asc';
export const QUERY_SORT_BY_DESC = 'urn:openproject-org:api:v3:queries:directions:desc';

export interface QuerySortByResourceEmbedded {
  column:QueryColumn;
  direction:QuerySortByDirection;
}

export class QuerySortByResource extends HalResource {
  public $embedded:QuerySortByResourceEmbedded;

  public column:QueryColumn;

  public direction:QuerySortByDirection;
}

/**
 * A direction for sorting
 */
export class QuerySortByDirection extends HalResource {
  public get id():string {
    return this.href!.split('/').pop()!;
  }
}

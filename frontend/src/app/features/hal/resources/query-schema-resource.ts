

import { QueryColumn } from 'core-app/features/work-packages/components/wp-query/query-column';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { QuerySortByResource } from 'core-app/features/hal/resources/query-sort-by-resource';
import { QueryFilterInstanceSchemaResource } from 'core-app/features/hal/resources/query-filter-instance-schema-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { QueryGroupByResource } from 'core-app/features/hal/resources/query-group-by-resource';

export class QuerySchemaResource extends SchemaResource {
  columns:{ allowedValues:QueryColumn[] };

  filtersSchemas:CollectionResource<QueryFilterInstanceSchemaResource>;

  sortBy:{ allowedValues:QuerySortByResource[] };

  groupBy:{ allowedValues:QueryGroupByResource[] };

  displayRepresentation:{ allowedValues:'list'|'card' };
}

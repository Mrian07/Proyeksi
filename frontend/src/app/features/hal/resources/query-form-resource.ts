

import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { FormResource } from 'core-app/features/hal/resources/form-resource';
import { QueryFilterInstanceSchemaResource } from 'core-app/features/hal/resources/query-filter-instance-schema-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

export interface QueryFormResourceEmbedded {
  filtersSchemas:CollectionResource<QueryFilterInstanceSchemaResource>;
  schema:SchemaResource;
}

export class QueryFormResource extends FormResource {
  public $embedded:QueryFormResourceEmbedded;

  public schema:SchemaResource;

  public get filtersSchemas():QueryFilterInstanceSchemaResource[] {
    return this.$embedded.filtersSchemas.elements;
  }
}

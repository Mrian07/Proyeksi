

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { QueryFilterInstanceSchemaResource } from 'core-app/features/hal/resources/query-filter-instance-schema-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

export interface QueryFilterResourceEmbedded {
  schema:QueryFilterInstanceSchemaResource;
}

export class QueryFilterResource extends HalResource {
  public $embedded:QueryFilterResourceEmbedded;

  public values:any[];

  public get id():string {
    return this.$source.id || idFromLink(this.href);
  }

  public set id(newId:string) {
    this.$source.id = newId;
  }
}

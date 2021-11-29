

import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { HalLink } from 'core-app/features/hal/hal-link/hal-link';
import { QueryOperatorResource } from 'core-app/features/hal/resources/query-operator-resource';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { SchemaAttributeObject, SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { QueryFilterResource } from 'core-app/features/hal/resources/query-filter-resource';
import { SchemaDependencyResource } from 'core-app/features/hal/resources/schema-dependency-resource';

export interface QueryFilterInstanceSchemaResourceLinks {
  self:HalLink;
  filter:QueryFilterResource;
}

export class QueryFilterInstanceSchemaResource extends SchemaResource {
  public $links:QueryFilterInstanceSchemaResourceLinks;

  public operator:SchemaAttributeObject;

  public filter:SchemaAttributeObject<QueryFilterResource>;

  public dependency:SchemaDependencyResource;

  public values:SchemaAttributeObject|null;

  public type = 'QueryFilterInstanceSchema';

  public get availableOperators():HalResource[] | CollectionResource {
    return this.operator.allowedValues;
  }

  public get allowedFilterValue():QueryFilterResource {
    if (this.filter.allowedValues instanceof CollectionResource) {
      return this.filter.allowedValues.elements[0];
    }

    return this.filter.allowedValues[0];
  }

  public $initialize(source:any) {
    super.$initialize(source);

    if (source._dependencies) {
      this.dependency = new SchemaDependencyResource(this.injector, source._dependencies[0], true, this.halInitializer, 'SchemaDependency');
    }
  }

  public getFilter():QueryFilterInstanceResource {
    const operator = (this.operator.allowedValues as HalResource[])[0];
    const filter = (this.filter.allowedValues as HalResource[])[0];
    const source:any = {
      name: filter.name,
      _links: {
        filter: filter.$source._links.self,
        schema: this.$source._links.self,
        operator: operator.$source._links.self,
      },
    };

    if (this.definesAllowedValues()) {
      source._links.values = [];
    } else {
      source.values = [];
    }

    return new QueryFilterInstanceResource(this.injector, source, true, this.halInitializer, 'QueryFilterInstance');
  }

  public isValueRequired():boolean {
    return !!(this.values);
  }

  public isResourceValue():boolean {
    return !!(this.values && this.values.allowedValues);
  }

  public resultingSchema(operator:QueryOperatorResource):QueryFilterInstanceSchemaResource {
    const staticSchema = this.$source;
    const dependentSchema = this.dependency.forValue(operator.href!.toString());
    const resultingSchema = {};

    _.merge(resultingSchema, staticSchema, dependentSchema);

    return new QueryFilterInstanceSchemaResource(this.injector, resultingSchema, true, this.halInitializer, 'QueryFilterInstanceSchema');
  }

  private definesAllowedValues() {
    return _.some(this._dependencies[0].dependencies,
      (dependency:any) => dependency.values && dependency.values._links && dependency.values._links.allowedValues);
  }
}

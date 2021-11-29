

import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { QueryOperatorResource } from 'core-app/features/hal/resources/query-operator-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';
import { QueryFilterInstanceSchemaResource } from 'core-app/features/hal/resources/query-filter-instance-schema-resource';
import { QueryFilterResource } from 'core-app/features/hal/resources/query-filter-resource';

export class QueryFilterInstanceResource extends HalResource {
  public filter:QueryFilterResource;

  public operator:QueryOperatorResource;

  public values:HalResource[]|string[];

  private memoizedCurrentSchemas:{ [key:string]:QueryFilterInstanceSchemaResource } = {};

  @InjectField(SchemaCacheService) schemaCache:SchemaCacheService;

  @InjectField(PathHelperService) pathHelper:PathHelperService;

  public $initialize(source:any) {
    super.$initialize(source);

    this.$links.schema = {
      href: `${this.pathHelper.api.v3.apiV3Base}/queries/filter_instance_schemas/${idFromLink(this.filter.href)}`,
    };
  }

  public get id():string {
    return this.filter.id;
  }

  public get name():string {
    return this.filter.name;
  }

  /**
   * Get the complete current schema.
   *
   * The filter instance's schema is made up of a static and a variable part.
   * The variable part depends on the currently selected operator.
   * Therefore, the schema differs based on the selected operator.
   */
  public get currentSchema():QueryFilterInstanceSchemaResource|null {
    if (!this.operator) {
      return null;
    }

    const key = this.operator.href!.toString();

    if (this.memoizedCurrentSchemas[key] === undefined) {
      try {
        this.memoizedCurrentSchemas[key] = this.schemaCache.of(this).resultingSchema(this.operator);
      } catch (e) {
        console.error(`Failed to access filter schema${e}`);
      }
    }

    return this.memoizedCurrentSchemas[key];
  }

  public isCompletelyDefined() {
    return this.values.length || (this.currentSchema && !this.currentSchema.isValueRequired());
  }

  public findOperator(operatorSymbol:string):QueryOperatorResource|undefined {
    return _.find(this.schemaCache.of(this).availableOperators, (operator:QueryOperatorResource) => operator.id === operatorSymbol) as QueryOperatorResource|undefined;
  }

  public isTemplated() {
    let flag = false;
    (this.values as any[]).find((value:any) => {
      const href:string = value?.href || value.toString() || '';
      flag = href.includes('{id}');
    });
    return flag;
  }
}

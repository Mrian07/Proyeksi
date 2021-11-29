

import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { Injectable } from '@angular/core';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { QueryFilterInstanceSchemaResource } from 'core-app/features/hal/resources/query-filter-instance-schema-resource';
import { QueryFormResource } from 'core-app/features/hal/resources/query-form-resource';
import { QueryFilterResource } from 'core-app/features/hal/resources/query-filter-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { QuerySortByResource } from 'core-app/features/hal/resources/query-sort-by-resource';
import { QueryGroupByResource } from 'core-app/features/hal/resources/query-group-by-resource';
import { QueryColumn } from '../wp-query/query-column';

@Injectable()
export class WorkPackagesListInvalidQueryService {
  constructor(protected halResourceService:HalResourceService) {
  }

  public restoreQuery(query:QueryResource, form:QueryFormResource) {
    this.restoreFilters(query, form.payload, form.schema);
    this.restoreColumns(query, form.payload, form.schema);
    this.restoreSortBy(query, form.payload, form.schema);
    this.restoreGroupBy(query, form.payload, form.schema);
    this.restoreOtherProperties(query, form.payload);
  }

  private restoreFilters(query:QueryResource, payload:QueryResource, querySchema:SchemaResource) {
    let filters = _.map((payload.filters), (filter) => {
      const filterInstanceSchema = _.find(querySchema.filtersSchemas.elements, (schema:QueryFilterInstanceSchemaResource) => (schema.filter.allowedValues as QueryFilterResource[])[0].href === filter.filter.href);

      if (!filterInstanceSchema) {
        return null;
      }

      const recreatedFilter = filterInstanceSchema.getFilter();

      const operator = _.find(filterInstanceSchema.operator.allowedValues, (operator) => operator.href === filter.operator.href);

      if (operator) {
        recreatedFilter.operator = operator;
      }

      recreatedFilter.values.length = 0;
      _.each(filter.values, (value) => recreatedFilter.values.push(value));

      return recreatedFilter;
    });

    filters = _.compact(filters);

    // clear filters while keeping reference
    query.filters.length = 0;
    _.each(filters, (filter) => query.filters.push(filter));
  }

  private restoreColumns(query:QueryResource, stubQuery:QueryResource, schema:SchemaResource) {
    let columns = _.map(stubQuery.columns, (column) => _.find((schema.columns.allowedValues as QueryColumn[]), (candidate) => candidate.href === column.href));

    columns = _.compact(columns);

    query.columns.length = 0;
    _.each(columns, (column) => query.columns.push(column!));
  }

  private restoreSortBy(query:QueryResource, stubQuery:QueryResource, schema:SchemaResource) {
    let sortBys = _.map((stubQuery.sortBy), (sortBy) => _.find((schema.sortBy.allowedValues as QuerySortByResource[]), (candidate) => candidate.href === sortBy.href)!);

    sortBys = _.compact(sortBys);

    query.sortBy.length = 0;
    _.each(sortBys, (sortBy) => query.sortBy.push(sortBy));
  }

  private restoreGroupBy(query:QueryResource, stubQuery:QueryResource, schema:SchemaResource) {
    const groupBy = _.find((schema.groupBy.allowedValues as QueryGroupByResource[]), (candidate) => stubQuery.groupBy && stubQuery.groupBy.href === candidate.href) as any;

    query.groupBy = groupBy;
  }

  private restoreOtherProperties(query:QueryResource, stubQuery:QueryResource) {
    _.without(Object.keys(stubQuery.$source), '_links', 'filters').forEach((property:any) => {
      query[property] = stubQuery[property];
    });

    _.without(Object.keys(stubQuery.$source._links), 'columns', 'groupBy', 'sortBy').forEach((property:any) => {
      query[property] = stubQuery[property];
    });
  }
}

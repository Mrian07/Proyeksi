

import { Injectable } from '@angular/core';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { WorkPackageViewPagination } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-table-pagination';
import { WorkPackageViewBaseService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-base.service';
import { PaginationObject, PaginationService } from 'core-app/shared/components/table-pagination/pagination-service';

export interface PaginationUpdateObject {
  page?:number;
  perPage?:number;
  total?:number;
  count?:number;
}

@Injectable()
export class WorkPackageViewPaginationService extends WorkPackageViewBaseService<WorkPackageViewPagination> {
  public constructor(querySpace:IsolatedQuerySpace,
    readonly paginationService:PaginationService) {
    super(querySpace);
  }

  public get paginationObject():PaginationObject {
    if (this.current) {
      return {
        pageSize: this.current.perPage,
        offset: this.current.page,
      };
    }
    return {
      pageSize: this.paginationService.getCachedPerPage([]),
      offset: 1,
    };
  }

  public valueFromQuery(query:QueryResource, results:WorkPackageCollectionResource) {
    return new WorkPackageViewPagination(results);
  }

  public updateFromObject(object:PaginationUpdateObject) {
    const currentState = this.current;

    if (object.page) {
      currentState.page = object.page;
    }
    if (object.perPage) {
      currentState.perPage = object.perPage;
    }
    if (object.total) {
      currentState.total = object.total;
    }

    this.updatesState.putValue(currentState);
  }

  public updateFromResults(results:WorkPackageCollectionResource) {
    const update = {
      page: results.offset,
      perPage: results.pageSize,
      total: results.total,
      count: results.count,
    };

    this.updateFromObject(update);
  }

  public get current():WorkPackageViewPagination {
    return this.lastUpdatedState.value!;
  }
}

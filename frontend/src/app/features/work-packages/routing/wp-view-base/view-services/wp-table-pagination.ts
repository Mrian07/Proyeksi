

import { PaginationInstance } from 'core-app/shared/components/table-pagination/pagination-instance';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';

export class WorkPackageViewPagination {
  public current:PaginationInstance;

  constructor(results:WorkPackageCollectionResource) {
    this.current = new PaginationInstance(results.offset, results.total, results.pageSize);
  }

  public get page() {
    return this.current.page;
  }

  public set page(val) {
    this.current.page = val;
  }

  public get perPage() {
    return this.current.perPage;
  }

  public set perPage(val) {
    this.current.perPage = val;
  }

  public get total() {
    return this.current.total;
  }

  public set total(val) {
    this.current.total = val;
  }
}

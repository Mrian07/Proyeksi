

import { StateService, TransitionPromise } from '@uirouter/core';
import { UrlParamsHelperService } from 'core-app/features/work-packages/components/wp-query/url-params-helper';
import { Injectable } from '@angular/core';
import { WorkPackageViewPagination } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-table-pagination';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';

@Injectable()
export class WorkPackagesListChecksumService {
  constructor(protected UrlParamsHelper:UrlParamsHelperService,
    protected $state:StateService) {
  }

  public id:string|null;

  public checksum:string|null;

  public visibleChecksum:string|null;

  public updateIfDifferent(query:QueryResource,
    pagination:WorkPackageViewPagination):Promise<unknown> {
    const newQueryChecksum = this.getNewChecksum(query, pagination);
    let routePromise:Promise<unknown> = Promise.resolve();

    if (this.isUninitialized()) {
      // Do nothing
    } else if (this.isIdDifferent(query.id)) {
      routePromise = this.maintainUrlQueryState(query.id, null);

      this.clear();
    } else if (this.isChecksumDifferent(newQueryChecksum)) {
      routePromise = this.maintainUrlQueryState(query.id, newQueryChecksum);
    }

    this.set(query.id, newQueryChecksum);
    return routePromise;
  }

  public update(query:QueryResource, pagination:WorkPackageViewPagination) {
    const newQueryChecksum = this.getNewChecksum(query, pagination);

    this.set(query.id, newQueryChecksum);

    this.maintainUrlQueryState(query.id, newQueryChecksum);
  }

  public setToQuery(query:QueryResource, pagination:WorkPackageViewPagination) {
    const newQueryChecksum = this.getNewChecksum(query, pagination);

    this.set(query.id, newQueryChecksum);

    return this.maintainUrlQueryState(query.id, null);
  }

  public isQueryOutdated(query:QueryResource,
    pagination:WorkPackageViewPagination) {
    const newQueryChecksum = this.getNewChecksum(query, pagination);

    return this.isOutdated(query.id, newQueryChecksum);
  }

  public executeIfOutdated(newId:string,
    newChecksum:string|null,
    callback:Function) {
    if (this.isUninitialized() || this.isOutdated(newId, newChecksum)) {
      this.set(newId, newChecksum);

      callback();
    }
  }

  private set(id:string|null, checksum:string|null) {
    this.id = id;
    this.checksum = checksum;
  }

  public clear() {
    this.id = null;
    this.checksum = null;
    this.visibleChecksum = null;
  }

  public isUninitialized() {
    return !this.id && !this.checksum;
  }

  private isIdDifferent(otherId:string|null) {
    return this.id !== otherId;
  }

  private isChecksumDifferent(otherChecksum:string) {
    return this.checksum && otherChecksum !== this.checksum;
  }

  private isOutdated(otherId:string|null, otherChecksum:string|null) {
    const hasCurrentQueryID = !!this.id;
    const hasCurrentChecksum = !!this.checksum;
    const idChanged = (this.id !== otherId);

    const checksumChanged = (otherChecksum !== this.checksum);
    const visibleChecksumChanged = (this.checksum && !otherChecksum && this.visibleChecksum);

    return (
      // Can only be outdated if either ID or props set
      (hasCurrentQueryID || hasCurrentChecksum)
      && (
        // Query ID changed
        idChanged
        // Query ID same + query props changed
        || (!idChanged && checksumChanged && (otherChecksum || this.visibleChecksum))
        // No query ID set
        || (!hasCurrentQueryID && visibleChecksumChanged)
      )
    );
  }

  private getNewChecksum(query:QueryResource, pagination:WorkPackageViewPagination) {
    return this.UrlParamsHelper.encodeQueryJsonParams(query, _.pick(pagination, ['page', 'perPage']));
  }

  private maintainUrlQueryState(id:string|null, checksum:string|null):TransitionPromise {
    this.visibleChecksum = checksum;

    return this.$state.go(
      '.',
      { query_props: checksum, query_id: id },
      { custom: { notify: false } },
    );
  }
}

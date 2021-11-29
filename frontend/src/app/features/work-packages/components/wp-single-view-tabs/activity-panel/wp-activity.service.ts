

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Injectable } from '@angular/core';
import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { WorkPackageLinkedResourceCache } from 'core-app/features/work-packages/components/wp-single-view-tabs/wp-linked-resource-cache.service';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { ActivityEntryInfo } from './activity-entry-info';

@Injectable()
export class WorkPackagesActivityService extends WorkPackageLinkedResourceCache<HalResource[]> {
  constructor(public ConfigurationService:ConfigurationService,
    readonly timezoneService:TimezoneService) {
    super();
  }

  public get order() {
    return this.isReversed ? 'desc' : 'asc';
  }

  public get isReversed():boolean {
    return !!this.ConfigurationService.commentsSortedInDescendingOrder();
  }

  /**
   * Aggregate user and revision activities for the given work package resource.
   * Resolves both promises and returns a sorted list of activities
   * whose order depends on the 'commentsSortedInDescendingOrder' property.
   */
  protected load(workPackage:WorkPackageResource):Promise<HalResource[]> {
    const aggregated:any[] = []; const
      promises:Promise<any>[] = [];

    const add = function (data:any) {
      aggregated.push(data.elements);
    };

    promises.push(workPackage.activities.$update().then(add));

    if (workPackage.revisions) {
      promises.push(workPackage.revisions.$update().then(add));
    }
    return Promise.all(promises).then(() => this.sortedActivityList(aggregated));
  }

  protected sortedActivityList(activities:HalResource[], attr = 'createdAt'):HalResource[] {
    const sorted = _.sortBy(_.flatten(activities), attr);

    if (this.isReversed) {
      return sorted.reverse();
    }
    return sorted;
  }

  public info(activities:HalResource[], activity:HalResource, index:number) {
    return new ActivityEntryInfo(this.timezoneService, this.isReversed, activities, activity, index);
  }
}



import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { HalResource } from "core-app/features/hal/resources/hal-resource";
import { Injectable } from '@angular/core';
import { ConfigurationService } from "core-app/core/config/configuration.service";
import { WorkPackageLinkedResourceCache } from 'core-app/features/work-packages/components/wp-single-view-tabs/wp-linked-resource-cache.service';

@Injectable()
export class WorkPackagesGithubPrsService extends WorkPackageLinkedResourceCache<HalResource[]> {

  constructor(public ConfigurationService:ConfigurationService) {
    super();
  }

  protected load(workPackage:WorkPackageResource):Promise<HalResource[]> {
    return workPackage.github_pull_requests.$update().then((data:any) => {
      return this.sortList(data.elements);
    });
  }

  protected sortList(pullRequests:HalResource[], attr = 'createdAt'):HalResource[] {
    return _.sortBy(_.flatten(pullRequests), attr);
  }
}

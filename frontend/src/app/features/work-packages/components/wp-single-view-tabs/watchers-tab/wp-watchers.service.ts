

import { Injectable } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { WorkPackageLinkedResourceCache } from 'core-app/features/work-packages/components/wp-single-view-tabs/wp-linked-resource-cache.service';

@Injectable()
export class WorkPackageWatchersService extends WorkPackageLinkedResourceCache<HalResource[]> {
  protected load(workPackage:WorkPackageResource) {
    return workPackage.watchers.$update()
      .then((collection:CollectionResource<HalResource>) => collection.elements);
  }
}

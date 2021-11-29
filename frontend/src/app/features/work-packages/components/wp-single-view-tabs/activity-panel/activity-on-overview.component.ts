

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { ActivityPanelBaseController } from 'core-app/features/work-packages/components/wp-single-view-tabs/activity-panel/activity-base.controller';
import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { ActivityEntryInfo } from 'core-app/features/work-packages/components/wp-single-view-tabs/activity-panel/activity-entry-info';
import { trackByProperty } from 'core-app/shared/helpers/angular/tracking-functions';

@Component({
  selector: 'newest-activity-on-overview',
  templateUrl: './activity-on-overview.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class NewestActivityOnOverviewComponent extends ActivityPanelBaseController {
  @Input('workPackage') public workPackage:WorkPackageResource;

  public latestActivityInfo:ActivityEntryInfo[] = [];

  public trackByHref = trackByProperty('identifier');

  ngOnInit() {
    this.workPackageId = this.workPackage.id!;
    super.ngOnInit();
  }

  protected shouldShowToggler() {
    return false;
  }

  protected updateActivities(activities:any) {
    super.updateActivities(activities);
    this.latestActivityInfo = this.latestActivities();
  }

  private latestActivities(visible = 3) {
    if (this.reverse) {
      // In reverse, we already get reversed entries from API.
      // So simply take the first three
      const segment = this.unfilteredActivities.slice(0, visible);
      return segment.map((el:HalResource, i:number) => this.info(el, i));
    }
    // In ascending sort, take the last three items
    const segment = this.unfilteredActivities.slice(-visible);
    const startIndex = this.unfilteredActivities.length - segment.length;
    return segment.map((el:HalResource, i:number) => this.info(el, startIndex + i));
  }
}

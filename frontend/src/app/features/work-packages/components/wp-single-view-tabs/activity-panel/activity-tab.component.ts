

import { Component } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { trackByHrefAndProperty } from 'core-app/shared/helpers/angular/tracking-functions';
import { ActivityPanelBaseController } from 'core-app/features/work-packages/components/wp-single-view-tabs/activity-panel/activity-base.controller';

@Component({
  templateUrl: './activity-tab.html',
  selector: 'wp-activity-tab',
})
export class WorkPackageActivityTabComponent extends ActivityPanelBaseController {
  public workPackage:WorkPackageResource;

  public tabName = this.I18n.t('js.work_packages.tabs.activity');

  public trackByHref = trackByHrefAndProperty('version');

  ngOnInit() {
    const { workPackageId } = this.uiRouterGlobals.params as unknown as { workPackageId:string };
    this.workPackageId = workPackageId;
    super.ngOnInit();
  }
}

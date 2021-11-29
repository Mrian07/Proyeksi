

import { ChangeDetectionStrategy, Component, OnInit } from '@angular/core';
import { take } from 'rxjs/operators';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { QueryParamListenerService } from 'core-app/features/work-packages/components/wp-query/query-param-listener.service';
import {
  PartitionedQuerySpacePageComponent,
  ToolbarButtonComponentDefinition,
} from 'core-app/features/work-packages/routing/partitioned-query-space-page/partitioned-query-space-page.component';
import { WorkPackageCreateButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-create-button/wp-create-button.component';
import { WorkPackageFilterButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-filter-button/wp-filter-button.component';
import { WorkPackageViewToggleButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-view-toggle-button/work-package-view-toggle-button.component';
import { WorkPackageDetailsViewButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-details-view-button/wp-details-view-button.component';
import { WorkPackageTimelineButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-timeline-toggle-button/wp-timeline-toggle-button.component';
import { ZenModeButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/zen-mode-toggle-button/zen-mode-toggle-button.component';
import { WorkPackageSettingsButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-settings-button/wp-settings-button.component';
import { of } from 'rxjs';
import { WorkPackageFoldToggleButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-fold-toggle-button/wp-fold-toggle-button.component';

@Component({
  selector: 'wp-view-page',
  templateUrl: '../partitioned-query-space-page/partitioned-query-space-page.component.html',
  styleUrls: [
    // Absolute paths do not work for styleURLs :-(
    '../partitioned-query-space-page/partitioned-query-space-page.component.sass',
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    /** We need to provide the wpNotification service here to get correct save notifications for WP resources */
    { provide: HalResourceNotificationService, useClass: WorkPackageNotificationService },
    QueryParamListenerService,
  ],
})
export class WorkPackageViewPageComponent extends PartitionedQuerySpacePageComponent implements OnInit {
  toolbarButtonComponents:ToolbarButtonComponentDefinition[] = [
    {
      component: WorkPackageCreateButtonComponent,
      inputs: {
        stateName$: of('work-packages.partitioned.list.new'),
        allowed: ['work_packages.createWorkPackage'],
      },
    },
    {
      component: WorkPackageFilterButtonComponent,
    },
    {
      component: WorkPackageViewToggleButtonComponent,
      containerClasses: 'hidden-for-mobile',
    },
    {
      component: WorkPackageFoldToggleButtonComponent,
      show: () => !!(this.currentQuery && this.currentQuery.groupBy),
    },
    {
      component: WorkPackageDetailsViewButtonComponent,
      containerClasses: 'hidden-for-mobile',
    },
    {
      component: WorkPackageTimelineButtonComponent,
      containerClasses: 'hidden-for-mobile -no-spacing',
    },
    {
      component: ZenModeButtonComponent,
      containerClasses: 'hidden-for-mobile',
    },
    {
      component: WorkPackageSettingsButtonComponent,
    },
  ];

  ngOnInit() {
    super.ngOnInit();
    this.text.button_settings = this.I18n.t('js.button_settings');
  }

  protected additionalLoadingTime():Promise<unknown> {
    if (this.wpTableTimeline.isVisible) {
      return this.querySpace.timelineRendered.pipe(take(1)).toPromise();
    }
    return this.querySpace.tableRendered.valuesPromise() as Promise<unknown>;
  }

  protected shouldUpdateHtmlTitle():boolean {
    return this.$state.current.name === 'work-packages.partitioned.list';
  }
}

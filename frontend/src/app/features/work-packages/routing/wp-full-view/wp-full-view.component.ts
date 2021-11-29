

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { StateService } from '@uirouter/core';
import { Component, Injector, OnInit } from '@angular/core';
import { Observable, of } from 'rxjs';
import { WorkPackageViewSelectionService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-selection.service';
import { WorkPackageSingleViewBase } from 'core-app/features/work-packages/routing/wp-view-base/work-package-single-view.base';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { WpSingleViewService } from 'core-app/features/work-packages/routing/wp-view-base/state/wp-single-view.service';

@Component({
  templateUrl: './wp-full-view.html',
  selector: 'wp-full-view-entry',
  // Required class to support inner scrolling on page
  host: { class: 'work-packages-page--ui-view' },
  providers: [
    WpSingleViewService,
    { provide: HalResourceNotificationService, useExisting: WorkPackageNotificationService },
  ],
})
export class WorkPackagesFullViewComponent extends WorkPackageSingleViewBase implements OnInit {
  // Watcher properties
  public isWatched:boolean;

  public displayWatchButton:boolean;

  public watchers:any;

  stateName$ = of('work-packages.new');

  constructor(
    public injector:Injector,
    public wpTableSelection:WorkPackageViewSelectionService,
    readonly $state:StateService,
  ) {
    super(injector, $state.params.workPackageId);
  }

  ngOnInit():void {
    this.observeWorkPackage();
  }

  protected initializeTexts() {
    super.initializeTexts();

    this.text.full_view = {
      button_more: this.I18n.t('js.button_more'),
    };
  }

  protected init() {
    super.init();

    // Set Focused WP
    this.wpTableFocus.updateFocus(this.workPackage.id!);

    this.setWorkPackageScopeProperties(this.workPackage);
  }

  private setWorkPackageScopeProperties(wp:WorkPackageResource) {
    this.isWatched = wp.hasOwnProperty('unwatch');
    this.displayWatchButton = wp.hasOwnProperty('unwatch') || wp.hasOwnProperty('watch');

    // watchers
    if (wp.watchers) {
      this.watchers = (wp.watchers as any).elements;
    }
  }
}

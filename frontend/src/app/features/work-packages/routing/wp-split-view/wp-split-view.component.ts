

import {
  ChangeDetectionStrategy,
  Component,
  Injector,
  OnInit,
} from '@angular/core';
import { StateService } from '@uirouter/core';
import { WorkPackageViewFocusService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-focus.service';
import { States } from 'core-app/core/states/states.service';
import { FirstRouteService } from 'core-app/core/routing/first-route-service';
import { KeepTabService } from 'core-app/features/work-packages/components/wp-single-view-tabs/keep-tab/keep-tab.service';
import { WorkPackageViewSelectionService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-selection.service';
import { WorkPackageSingleViewBase } from 'core-app/features/work-packages/routing/wp-view-base/work-package-single-view.base';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { BackRoutingService } from 'core-app/features/work-packages/components/back-routing/back-routing.service';
import { WpSingleViewService } from 'core-app/features/work-packages/routing/wp-view-base/state/wp-single-view.service';

@Component({
  templateUrl: './wp-split-view.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'op-wp-split-view',
  providers: [
    WpSingleViewService,
    { provide: HalResourceNotificationService, useClass: WorkPackageNotificationService },
  ],
})
export class WorkPackageSplitViewComponent extends WorkPackageSingleViewBase implements OnInit {
  /** Reference to the base route e.g., work-packages.partitioned.list or bim.partitioned.split */
  private baseRoute:string = this.$state.current.data.baseRoute;

  constructor(
    public injector:Injector,
    public states:States,
    public firstRoute:FirstRouteService,
    public keepTab:KeepTabService,
    public wpTableSelection:WorkPackageViewSelectionService,
    public wpTableFocus:WorkPackageViewFocusService,
    readonly $state:StateService,
    readonly backRouting:BackRoutingService,
  ) {
    super(injector, $state.params.workPackageId);
  }

  ngOnInit():void {
    this.observeWorkPackage();

    const wpId = this.$state.params.workPackageId;
    const focusedWP = this.wpTableFocus.focusedWorkPackage;

    if (!focusedWP) {
      // Focus on the work package if we're the first route
      const isFirstRoute = this.firstRoute.name === `${this.baseRoute}.details.overview`;
      const isSameID = this.firstRoute.params && wpId === this.firstRoute.params.workPackageI;
      this.wpTableFocus.updateFocus(wpId, (isFirstRoute && isSameID));
    } else {
      this.wpTableFocus.updateFocus(wpId, false);
    }

    if (this.wpTableSelection.isEmpty) {
      this.wpTableSelection.setRowState(wpId, true);
    }

    this.wpTableFocus.whenChanged()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((newId) => {
        const idSame = wpId.toString() === newId.toString();
        if (!idSame && this.$state.includes(`${this.baseRoute}.details`)) {
          this.$state.go(
            (this.$state.current.name as string),
            { workPackageId: newId, focus: false },
          );
        }
      });
  }

  get shouldFocus():boolean {
    return this.$state.params.focus === true;
  }

  showBackButton():boolean {
    return this.baseRoute.includes('bim');
  }

  backToList():void {
    this.backRouting.goToBaseState();
  }

  protected handleLoadingError(error:unknown):void {
    const message = this.notificationService.retrieveErrorMessage(error);

    // Go back to the base route, closing this split view
    void this.$state.go(
      this.baseRoute,
      { flash_message: { type: 'error', message } },
    );
  }
}

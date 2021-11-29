

import { WorkPackagesListService } from 'core-app/features/work-packages/components/wp-list/wp-list.service';
import { States } from 'core-app/core/states/states.service';
import {
  ChangeDetectorRef, Component, ElementRef, Inject, OnInit,
} from '@angular/core';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { OpModalLocalsToken } from 'core-app/shared/components/modal/modal.service';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { WorkPackageViewFocusService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-focus.service';
import { StateService } from '@uirouter/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { BackRoutingService } from 'core-app/features/work-packages/components/back-routing/back-routing.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { WorkPackageService } from 'core-app/features/work-packages/services/work-package.service';

@Component({
  templateUrl: './wp-destroy.modal.html',
})
export class WpDestroyModalComponent extends OpModalComponent implements OnInit {
  // When deleting multiple
  public workPackages:WorkPackageResource[];

  public workPackageLabel:string;

  // Single work package
  public singleWorkPackage:WorkPackageResource;

  public singleWorkPackageChildren:WorkPackageResource[];

  public busy = false;

  // Need to confirm deletion when children are involved
  public childrenDeletionConfirmed = false;

  public text:any = {
    label_visibility_settings: this.I18n.t('js.label_visibility_settings'),
    button_save: this.I18n.t('js.modals.button_save'),
    confirm: this.I18n.t('js.button_confirm'),
    warning: this.I18n.t('js.label_warning'),
    cancel: this.I18n.t('js.button_cancel'),
    close: this.I18n.t('js.close_popup_title'),
    label_confirm_children_deletion: this.I18n.t('js.modals.destroy_work_package.confirm_deletion_children'),
  };

  constructor(readonly elementRef:ElementRef,
    readonly WorkPackageService:WorkPackageService,
    @Inject(OpModalLocalsToken) public locals:OpModalLocalsMap,
    readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef,
    readonly $state:StateService,
    readonly states:States,
    readonly wpTableFocus:WorkPackageViewFocusService,
    readonly wpListService:WorkPackagesListService,
    readonly notificationService:WorkPackageNotificationService,
    readonly backRoutingService:BackRoutingService) {
    super(locals, cdRef, elementRef);
  }

  ngOnInit() {
    super.ngOnInit();

    this.workPackages = this.locals.workPackages;
    this.workPackageLabel = this.I18n.t('js.units.workPackage', { count: this.workPackages.length });

    // Ugly way to provide the same view bindings as the ng-init in the previous template.
    if (this.workPackages.length === 1) {
      this.singleWorkPackage = this.workPackages[0];
      this.singleWorkPackageChildren = this.singleWorkPackage.children;
    }

    this.text.title = this.I18n.t('js.modals.destroy_work_package.title', { label: this.workPackageLabel }),
    this.text.text = this.I18n.t('js.modals.destroy_work_package.text', {
      label: this.workPackageLabel,
      count: this.workPackages.length,
    });

    this.text.childCount = (wp:WorkPackageResource) => {
      const count = this.children(wp).length;
      return this.I18n.t('js.units.child_work_packages', { count });
    };

    this.text.hasChildren = (wp:WorkPackageResource) => this.I18n.t('js.modals.destroy_work_package.has_children', { childUnits: this.text.childCount(wp) }),

    this.text.deletesChildren = this.I18n.t('js.modals.destroy_work_package.deletes_children');
  }

  public get blockedDueToUnconfirmedChildren() {
    return this.mustConfirmChildren && !this.childrenDeletionConfirmed;
  }

  public get mustConfirmChildren() {
    const result = false;

    if (this.singleWorkPackage && this.singleWorkPackageChildren) {
      const result = this.singleWorkPackageChildren.length > 0;
    }

    return result || !!_.find(this.workPackages, (wp) => wp.children && wp.children.length > 0);
  }

  public confirmDeletion($event:JQuery.TriggeredEvent) {
    if (this.busy || this.blockedDueToUnconfirmedChildren) {
      return false;
    }

    this.busy = true;
    this.WorkPackageService.performBulkDelete(this.workPackages.map((el) => el.id!), true)
      .then(() => {
        this.busy = false;
        this.closeMe($event);
        this.wpTableFocus.clear('Clearing after destroying work packages');

        // Go back to a previous list state if we're in a split or full view
        if (this.$state.current.data.baseRoute) {
          this.backRoutingService.goBack(true);
        }
      })
      .catch(() => {
        this.busy = false;
      });

    return false;
  }

  public children(workPackage:WorkPackageResource) {
    if (workPackage.hasOwnProperty('children')) {
      return workPackage.children;
    }
    return [];
  }
}

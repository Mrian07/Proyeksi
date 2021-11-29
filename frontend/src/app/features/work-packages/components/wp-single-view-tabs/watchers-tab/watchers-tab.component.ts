

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, ElementRef, OnInit,
} from '@angular/core';
import { Transition } from '@uirouter/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { LoadingIndicatorService } from 'core-app/core/loading-indicator/loading-indicator.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageWatchersService } from 'core-app/features/work-packages/components/wp-single-view-tabs/watchers-tab/wp-watchers.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { trackByHref } from 'core-app/shared/helpers/angular/tracking-functions';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  templateUrl: './watchers-tab.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'wp-watchers-tab',
})
export class WorkPackageWatchersTabComponent extends UntilDestroyedMixin implements OnInit {
  public workPackageId:string;

  public workPackage:WorkPackageResource;

  public trackByHref = trackByHref;

  public error = false;

  public noResults = false;

  public allowedToView = false;

  public allowedToAdd = false;

  public allowedToRemove = false;

  public availableWatchersPath:string;

  private $element:JQuery;

  public watching:any[] = [];

  public text = {
    loading: this.I18n.t('js.watchers.label_loading'),
    loadingError: this.I18n.t('js.watchers.label_error_loading'),
    autocomplete: {
      placeholder: this.I18n.t('js.watchers.typeahead_placeholder'),
    },
  };

  public constructor(readonly I18n:I18nService,
    readonly elementRef:ElementRef,
    readonly wpWatchersService:WorkPackageWatchersService,
    readonly $transition:Transition,
    readonly notificationService:WorkPackageNotificationService,
    readonly loadingIndicator:LoadingIndicatorService,
    readonly cdRef:ChangeDetectorRef,
    readonly pathHelper:PathHelperService,
    readonly apiV3Service:APIV3Service) {
    super();
  }

  public ngOnInit() {
    this.$element = jQuery(this.elementRef.nativeElement);

    this.workPackageId = this.$transition.params('to').workPackageId;
    this
      .apiV3Service
      .work_packages
      .id(this.workPackageId)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp:WorkPackageResource) => {
        this.workPackage = wp;
        this.loadCurrentWatchers();
      });

    this.availableWatchersPath = this.apiV3Service.work_packages.id(this.workPackageId).available_watchers.path;
  }

  public loadCurrentWatchers() {
    this.error = false;
    this.allowedToView = !!this.workPackage.watchers;
    this.allowedToAdd = !!this.workPackage.addWatcher;
    this.allowedToRemove = !!this.workPackage.removeWatcher;

    if (!this.allowedToView) {
      this.error = true;
      return;
    }

    this.wpWatchersService.require(this.workPackage)
      .then((watchers:HalResource[]) => {
        this.watching = watchers;
        this.cdRef.detectChanges();
      })
      .catch((error:any) => {
        this.notificationService.showError(error, this.workPackage);
      });
  }

  public set loadingPromise(promise:Promise<any>) {
    this.loadingIndicator.wpDetails.promise = promise;
  }

  public addWatcher(user:any) {
    this.loadingPromise = this.workPackage.addWatcher.$link.$fetch({ user: { href: user.href } })
      .then(() => {
        // Forcefully reload the resource to update the watch/unwatch links
        // should the current user have been added
        this.wpWatchersService.require(this.workPackage, true);
        this
          .apiV3Service
          .work_packages
          .id(this.workPackage)
          .refresh();

        this.cdRef.detectChanges();
      })
      .catch((error:any) => this.notificationService.showError(error, this.workPackage));
  }

  public removeWatcher(watcher:any) {
    this.workPackage.removeWatcher.$link.$prepare({ user_id: watcher.id })()
      .then(() => {
        _.remove(this.watching, (other:HalResource) => other.href === watcher.href);

        // Forcefully reload the resource to update the watch/unwatch links
        // should the current user have been removed
        this.wpWatchersService.require(this.workPackage, true);
        this
          .apiV3Service
          .work_packages
          .id(this.workPackage)
          .refresh();
        this.cdRef.detectChanges();
      })
      .catch((error:any) => this.notificationService.showError(error, this.workPackage));
  }
}

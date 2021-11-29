

import {
  ChangeDetectorRef,
  Injector,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { WorkPackageViewFocusService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-focus.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { OpTitleService } from 'core-app/core/html/op-title.service';
import { AuthorisationService } from 'core-app/core/model-auth/model-auth.service';
import { States } from 'core-app/core/states/states.service';
import { KeepTabService } from 'core-app/features/work-packages/components/wp-single-view-tabs/keep-tab/keep-tab.service';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { HookService } from 'core-app/features/plugins/hook-service';
import { WpSingleViewService } from 'core-app/features/work-packages/routing/wp-view-base/state/wp-single-view.service';
import { Observable } from 'rxjs';
import { ActionsService } from 'core-app/core/state/actions/actions.service';

export class WorkPackageSingleViewBase extends UntilDestroyedMixin {
  @InjectField() states:States;

  @InjectField() I18n!:I18nService;

  @InjectField() keepTab:KeepTabService;

  @InjectField() PathHelper:PathHelperService;

  @InjectField() halEditing:HalResourceEditingService;

  @InjectField() wpTableFocus:WorkPackageViewFocusService;

  @InjectField() notificationService:WorkPackageNotificationService;

  @InjectField() authorisationService:AuthorisationService;

  @InjectField() cdRef:ChangeDetectorRef;

  @InjectField() readonly titleService:OpTitleService;

  @InjectField() readonly apiV3Service:APIV3Service;

  @InjectField() readonly hooks:HookService;

  @InjectField() readonly actions$:ActionsService;

  @InjectField() readonly storeService:WpSingleViewService;

  // Static texts
  public text:any = {};

  // Work package resource to be loaded from the cache
  public workPackage:WorkPackageResource;

  public projectIdentifier:string;

  public focusAnchorLabel:string;

  public showStaticPagePath:string;

  public displayNotificationsButton$:Observable<boolean>;

  constructor(public injector:Injector,
    protected workPackageId:string) {
    super();
    this.initializeTexts();
  }

  /**
   * Observe changes of work package and re-run initialization.
   * Needs to be run explicitly by descendants.
   */
  protected observeWorkPackage() {
    this
      .apiV3Service
      .work_packages
      .id(this.workPackageId)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp:WorkPackageResource) => {
        if (!this.workPackage) {
          this.workPackage = wp;
          this.init();
        } else {
          this.workPackage = wp;
        }

        this.cdRef.detectChanges();
      },
      (error) => {
        this.handleLoadingError(error);
      });
  }

  /**
   * Provide static translations
   */
  protected initializeTexts() {
    this.text.tabs = {};
    ['overview', 'activity', 'relations', 'watchers'].forEach((tab) => {
      this.text.tabs[tab] = this.I18n.t(`js.work_packages.tabs.${tab}`);
    });
  }

  /**
   * Initialize controller after workPackage resource has been loaded.
   */
  protected init() {
    // Set elements
    this
      .apiV3Service
      .projects
      .id(this.workPackage.project)
      .requireAndStream()
      .subscribe(() => {
        this.projectIdentifier = this.workPackage.project.identifier;
        this.cdRef.detectChanges();
      });

    this.displayNotificationsButton$ = this.storeService.query.hasNotifications$;
    this.storeService.setFilters(this.workPackage.id as string);

    // Set authorisation data
    this.authorisationService.initModelAuth('work_package', this.workPackage.$links);

    // Push the current title
    this.titleService.setFirstPart(this.workPackage.subjectWithType(20));

    // Preselect this work package for future list operations
    this.showStaticPagePath = this.PathHelper.workPackagePath(this.workPackageId);

    // Listen to tab changes to update the tab label
    this.keepTab.observable
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((tabs:any) => {
        this.updateFocusAnchorLabel(tabs.active);
      });
  }

  protected handleLoadingError(error:unknown):void {
    this.notificationService.handleRawError(error);
  }

  /**
   * Recompute the current tab focus label
   */
  public updateFocusAnchorLabel(tabName:string):string {
    const tabLabel = this.I18n.t('js.label_work_package_details_you_are_here', {
      tab: this.I18n.t(`js.work_packages.tabs.${tabName}`),
      type: this.workPackage.type.name,
      subject: this.workPackage.subject,
    });

    return this.focusAnchorLabel = tabLabel;
  }
}

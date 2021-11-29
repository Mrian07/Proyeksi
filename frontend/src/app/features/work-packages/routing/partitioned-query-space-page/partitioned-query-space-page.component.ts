

import {
  ChangeDetectionStrategy,
  Component,
  OnDestroy,
  OnInit,
} from '@angular/core';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { OpTitleService } from 'core-app/core/html/op-title.service';
import { WorkPackagesViewBase } from 'core-app/features/work-packages/routing/wp-view-base/work-packages-view.base';
import { take } from 'rxjs/operators';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { QueryParamListenerService } from 'core-app/features/work-packages/components/wp-query/query-param-listener.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { ComponentType } from '@angular/cdk/overlay';
import { Ng2StateDeclaration } from '@uirouter/angular';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { InviteUserModalComponent } from 'core-app/features/invite-user-modal/invite-user.component';
import { WorkPackageFilterContainerComponent } from 'core-app/features/work-packages/components/filters/filter-container/filter-container.directive';
import isPersistedResource from 'core-app/features/hal/helpers/is-persisted-resource';

export interface DynamicComponentDefinition {
  component:ComponentType<any>;
  inputs?:{ [inputName:string]:any };
  outputs?:{ [outputName:string]:Function };
}

export interface ToolbarButtonComponentDefinition extends DynamicComponentDefinition {
  containerClasses?:string;
  show?:() => boolean;
}

export type ViewPartitionState = '-split'|'-left-only'|'-right-only';

@Component({
  templateUrl: './partitioned-query-space-page.component.html',
  styleUrls: ['./partitioned-query-space-page.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    /** We need to provide the wpNotification service here to get correct save notifications for WP resources */
    { provide: HalResourceNotificationService, useClass: WorkPackageNotificationService },
    QueryParamListenerService,
  ],
})
export class PartitionedQuerySpacePageComponent extends WorkPackagesViewBase implements OnInit, OnDestroy {
  @InjectField() I18n!:I18nService;

  @InjectField() titleService:OpTitleService;

  @InjectField() queryParamListener:QueryParamListenerService;

  @InjectField() opModalService:OpModalService;

  text:{ [key:string]:string } = {
    jump_to_pagination: this.I18n.t('js.work_packages.jump_marks.pagination'),
    text_jump_to_pagination: this.I18n.t('js.work_packages.jump_marks.label_pagination'),
  };

  /** Whether the title can be edited */
  titleEditingEnabled:boolean;

  /** Current query title to render */
  selectedTitle?:string;

  currentQuery:QueryResource|undefined;

  /** Whether we're saving the query */
  toolbarDisabled:boolean;

  /** Do we currently have query props ? */
  showToolbarSaveButton:boolean;

  /** Listener callbacks */
  // eslint-disable-next-line @typescript-eslint/ban-types
  removeTransitionSubscription:Function;

  /** Determine when query is initially loaded */
  showToolbar = false;

  /** The toolbar buttons to render */
  toolbarButtonComponents:ToolbarButtonComponentDefinition[] = [];

  /** Whether filtering is allowed */
  filterAllowed = true;

  /** We need to pass the correct partition state to the view to manage the grid */
  currentPartition:ViewPartitionState = '-split';

  /** What route (if any) should we go back to using the back button left of the title? */
  backButtonCallback:() => void|undefined;

  /** Which filter container component to mount */
  filterContainerDefinition:DynamicComponentDefinition = {
    component: WorkPackageFilterContainerComponent,
  };

  ngOnInit() {
    super.ngOnInit();

    this.showToolbarSaveButton = !!this.$state.params.query_props;
    this.setPartition(this.$state.current);
    this.removeTransitionSubscription = this.$transitions.onSuccess({}, (transition):any => {
      const params = transition.params('to');
      const toState = transition.to();
      this.showToolbarSaveButton = !!params.query_props;
      this.setPartition(toState);
      this.cdRef.detectChanges();
    });

    // Load the query. If it hasn't been loaded before, do that visibly.
    const isFirstLoad = !this.querySpace.initialized.hasValue();
    this.loadingIndicator = this.loadQuery(isFirstLoad);

    // Mark tableInformationLoaded when initially loading done
    this.setupInformationLoadedListener();

    // Load query on URL transitions
    this.queryParamListener
      .observe$
      .pipe(this.untilDestroyed())
      .subscribe(() => {
        /** Ensure we reload the query from the changed props */
        this.currentQuery = undefined;
        void this.refresh(true, true);
      });

    this.querySpace.query.values$()
      .pipe(this.untilDestroyed())
      .subscribe((query) => {
        // Update the title whenever the query changes
        this.updateTitle(query);
        this.currentQuery = query;
      });
  }

  /**
   * We need to set the current partition to the grid to ensure
   * either side gets expanded to full width if we're not in '-split' mode.
   *
   * @param state The current or entering state
   */
  protected setPartition(state:Ng2StateDeclaration):void {
    this.currentPartition = (state.data && state.data.partition) ? state.data.partition : '-split';
  }

  protected setupInformationLoadedListener():void {
    this
      .querySpace
      .initialized
      .values$()
      .pipe(take(1))
      .subscribe(() => {
        this.showToolbar = true;
        this.cdRef.detectChanges();
      });
  }

  ngOnDestroy():void {
    super.ngOnDestroy();
    this.removeTransitionSubscription();
    this.queryParamListener.removeQueryChangeListener();
  }

  public changeChangesFromTitle(val:string) {
    if (this.currentQuery && isPersistedResource(this.currentQuery)) {
      this.updateTitleName(val);
    } else {
      this.wpListService
        .create(this.currentQuery!, val)
        .then(() => this.toolbarDisabled = false)
        .catch(() => this.toolbarDisabled = false);
    }
  }

  updateTitleName(val:string) {
    this.toolbarDisabled = true;
    this.currentQuery!.name = val;
    this.wpListService.save(this.currentQuery)
      .then(() => this.toolbarDisabled = false)
      .catch(() => this.toolbarDisabled = false);
  }

  updateTitle(query?:QueryResource) {
    // Too early for loaded query
    if (!query) {
      return;
    }

    if (isPersistedResource(query)) {
      this.selectedTitle = query.name;
    } else {
      this.selectedTitle = this.opStaticQueries.getStaticName(query);
    }

    this.titleEditingEnabled = this.authorisationService.can('query', 'updateImmediately');

    // Update the title if we're in the list state alone
    if (this.shouldUpdateHtmlTitle()) {
      this.titleService.setFirstPart(this.selectedTitle);
    }
  }

  refresh(visibly = false, firstPage = false):Promise<unknown> {
    let promise = this.loadQuery(firstPage) as Promise<unknown>;

    if (visibly) {
      promise = promise.then((loadedQuery:QueryResource) => {
        this.wpStatesInitialization.initialize(loadedQuery, loadedQuery.results);
        return this.additionalLoadingTime();
      });

      this.loadingIndicator = promise;
    } else {
      promise = promise.then((loadedQuery:QueryResource) => {
        this.wpStatesInitialization.initialize(loadedQuery, loadedQuery.results);
      });
    }

    return promise;
  }

  protected inviteModal = InviteUserModalComponent;

  openInviteUserModal() {
    const inviteModal = this.opModalService.show(this.inviteModal, 'global');
    inviteModal.closingEvent.subscribe((modal:any) => {
      console.log('Modal closed!', modal);
    });
  }

  protected loadQuery(firstPage = false):Promise<QueryResource> {
    let promise:Promise<QueryResource>;
    const query = this.currentQuery;

    if (firstPage || !query) {
      promise = this.loadFirstPage();
    } else {
      const pagination = this.wpListService.getPaginationInfo();
      promise = this.wpListService
        .loadQueryFromExisting(query, pagination, this.projectIdentifier)
        .toPromise();
    }

    return promise;
  }

  protected loadFirstPage():Promise<QueryResource> {
    if (this.currentQuery) {
      return this.wpListService.reloadQuery(this.currentQuery, this.projectIdentifier).toPromise();
    }
    return this.wpListService.loadCurrentQueryFromParams(this.projectIdentifier);
  }

  protected additionalLoadingTime():Promise<unknown> {
    return Promise.resolve();
  }

  protected set loadingIndicator(promise:Promise<unknown>) {
    this.loadingIndicatorService.table.promise = promise;
  }

  protected shouldUpdateHtmlTitle():boolean {
    return true;
  }
}


import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  Injector,
  OnInit,
  ElementRef,
  NgZone,
} from '@angular/core';
import { take } from 'rxjs/operators';
import { CausedUpdatesService } from 'core-app/features/boards/board/caused-updates/caused-updates.service';
import { DragAndDropService } from 'core-app/shared/helpers/drag-and-drop/drag-and-drop.service';
import {
  WorkPackageViewDisplayRepresentationService,
  wpDisplayCardRepresentation,
} from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-display-representation.service';
import { WorkPackageTableConfigurationObject } from 'core-app/features/work-packages/components/wp-table/wp-table-configuration';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { DeviceService } from 'core-app/core/browser/device.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { WorkPackageViewFiltersService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-filters.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { StateService } from '@uirouter/core';
import { KeepTabService } from 'core-app/features/work-packages/components/wp-single-view-tabs/keep-tab/keep-tab.service';

@Component({
  selector: 'wp-list-view',
  templateUrl: './wp-list-view.component.html',
  styleUrls: ['./wp-list-view.component.sass'],
  host: { class: 'op-wp-list-view work-packages-split-view--tabletimeline-side' },
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    { provide: HalResourceNotificationService, useClass: WorkPackageNotificationService },
    DragAndDropService,
    CausedUpdatesService,
  ],
})
export class WorkPackageListViewComponent extends UntilDestroyedMixin implements OnInit {
  text = {
    jump_to_pagination: this.I18n.t('js.work_packages.jump_marks.pagination'),
    text_jump_to_pagination: this.I18n.t('js.work_packages.jump_marks.label_pagination'),
    button_settings: this.I18n.t('js.button_settings'),
  };

  /** Switch between list and card view */
  showTableView = true;

  /** Determine when query is initially loaded */
  tableInformationLoaded = false;

  /** If loaded list of work packages is empty */
  noResults = false;

  /** Whether we should render a blocked view */
  showResultOverlay$ = this.wpViewFilters.incomplete$;

  /** */
  readonly wpTableConfiguration:WorkPackageTableConfigurationObject = {
    dragAndDropEnabled: true,
  };

  constructor(readonly I18n:I18nService,
    readonly injector:Injector,
    readonly $state:StateService,
    readonly keepTab:KeepTabService,
    readonly querySpace:IsolatedQuerySpace,
    readonly wpViewFilters:WorkPackageViewFiltersService,
    readonly deviceService:DeviceService,
    readonly CurrentProject:CurrentProjectService,
    readonly wpDisplayRepresentation:WorkPackageViewDisplayRepresentationService,
    readonly cdRef:ChangeDetectorRef,
    readonly elementRef:ElementRef,
    private ngZone:NgZone) {
    super();
  }

  ngOnInit() {
    // Mark tableInformationLoaded when initially loading done
    this.setupInformationLoadedListener();

    this.querySpace.query.values$().pipe(
      this.untilDestroyed(),
    ).subscribe((query) => {
      // Update the visible representation
      this.updateViewRepresentation(query);
      this.noResults = query.results.total === 0;
      this.cdRef.detectChanges();
    });

    // Scroll into view the card/row that represents the last selected WorkPackage
    // so when the user opens a WP detail page on a split-view and then clicks on
    // the 'back button', the last selected card is visible on this list.
    // ngAfterViewInit doesn't find the .-checked elements on components
    // that inherit from this class (BcfListContainerComponent) so
    // opting for a timeout 'runOutsideAngular' to avoid running change
    // detection on the entire app
    this.ngZone.runOutsideAngular(() => {
      setTimeout(() => {
        const selectedRow = this.elementRef.nativeElement.querySelector('.wp-table--row.-checked');
        const selectedCard = this.elementRef.nativeElement.querySelector('[data-qa-selector="op-wp-single-card"].-checked');

        // The header of the table hides the scrolledIntoView element
        // so we scrollIntoView the previous element, if any
        if (selectedRow && selectedRow.previousSibling) {
          selectedRow.previousSibling.scrollIntoView({ block: 'start' });
        }

        if (selectedCard) {
          selectedCard.scrollIntoView({ block: 'start' });
        }
      }, 0);
    });
  }

  protected setupInformationLoadedListener() {
    this
      .querySpace
      .initialized
      .values$()
      .pipe(take(1))
      .subscribe(() => {
        this.tableInformationLoaded = true;
        this.cdRef.detectChanges();
      });
  }

  public showResizerInCardView():boolean {
    return false;
  }

  protected updateViewRepresentation(query:QueryResource) {
    this.showTableView = !(this.deviceService.isMobile
      || this.wpDisplayRepresentation.valueFromQuery(query) === wpDisplayCardRepresentation);
  }

  handleWorkPackageClicked(event:{ workPackageId:string; double:boolean }) {
    if (event.double) {
      this.openInFullView(event.workPackageId);
    }
  }

  openStateLink(event:{ workPackageId:string; requestedState:'show'|'split' }) {
    const params = {
      workPackageId: event.workPackageId,
      focus: true,
    };

    if (event.requestedState === 'split') {
      this.keepTab.goCurrentDetailsState(params);
    } else {
      this.keepTab.goCurrentShowState(params);
    }
  }

  /**
   * Special handling for clicking on cards.
   * If we are on mobile, a click on the card should directly open the full view
   */
  handleWorkPackageCardClicked(event:{ workPackageId:string; double:boolean }) {
    if (this.deviceService.isMobile) {
      this.openInFullView(event.workPackageId);
    } else {
      this.handleWorkPackageClicked(event);
    }
  }

  private openInFullView(workPackageId:string) {
    this.$state.go(
      'work-packages.show',
      { workPackageId },
    );
  }
}